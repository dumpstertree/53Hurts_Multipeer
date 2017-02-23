//
//  MultipeerController.swift
//  53 Hurts
//
//  Created by Zachary Collins on 1/3/17.
//  Copyright © 2017 dumpstertree. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class MultipeerController: NSObject {
    
    var nearbyPeers : [MCPeerID] = []
    var delegate: MultipeerControllerDelegate!
    
    let serviceType = "FiftyThreeHurts"
    let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    let serviceAdvertiser : MCNearbyServiceAdvertiser
    let serviceBrowser : MCNearbyServiceBrowser
    lazy var session : MCSession = {
        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.required)
        session.delegate = self
        return session
    }()
    
    var packetsWaitingForAck : [ String : TransformPacket2] = [:] // This needs to be a synchronized dictionary
    var packetResendTime = 10
    
    private var _incomingPackets = SynchronizedArray<Packet>()
    private var _outgoingPackets = SynchronizedArray<Packet>()
    
    override init(){
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: serviceType)
        serviceBrowser    = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        
        super.init()
        
        serviceAdvertiser.delegate = self
        serviceBrowser.delegate    = self
        DataUnpacker.delegates.append(self)
    }
    
    public func advertise( enabled: Bool){
        if enabled {
            serviceAdvertiser.startAdvertisingPeer()
        }
        else{
            serviceAdvertiser.stopAdvertisingPeer()
        }
    }
    public func browse( enabled: Bool ){
        if enabled {
            serviceBrowser.startBrowsingForPeers()
        }
        else{
            serviceBrowser.stopBrowsingForPeers()
        }
    }
    public func createSession(){
       
        for peer in nearbyPeers{
            serviceBrowser.invitePeer(peer, to: session, withContext: nil, timeout: 3)
        }
    }
    public func addIncomingPacket( packet: Packet ){
        _incomingPackets.append(newElement: packet)
    }
    public func addOutgoingPacket( packet: Packet ){
        _outgoingPackets.append(newElement: packet)
    }
    public func update(){
        push()
        pull()
    }
    
    private func push(){
       
        if session.connectedPeers.count == 0{
            return
        }
        
        // Send New Packets
        for i in 0..<_outgoingPackets.count() {
            do {
            
                // Get packet instance
                let packet = _outgoingPackets[i]
                
                // Ack Packets
                if let _ = packet as? AckPacket{
                    let cd = NSKeyedArchiver.archivedData(withRootObject: packet)
                    try session.send( cd, toPeers: session.connectedPeers, with: MCSessionSendDataMode.reliable)
                    continue;
                }
                
                // Transform Packet
                if let p = packet as? TransformPacket2{
                    try session.send( p.Data!, toPeers: session.connectedPeers, with: MCSessionSendDataMode.reliable)
                    continue;
                }
            }
            catch{
                print("COULD NOT CONVERT;")
                continue
            }
        }
        
        // Clear
        _outgoingPackets.removeAll()
    
        // Resend any packets still waiting for an ACK
        for (uuid,packet) in packetsWaitingForAck{
            let packetFrame = packet.frame as Int
            
            // Remove from ACK packets due to age
            if  FrameCounter.Frame - packetFrame > 30{
                packetsWaitingForAck.removeValue(forKey: uuid)
                continue
            }
            
            // Add to outgoing packets to send again next frame
            if ((FrameCounter.Frame-packetFrame) % packetResendTime) == 0 {
                _outgoingPackets.append( newElement: packet )
                print("RESENT : \(packet.frame)")
            }
        }
    }
    private func pull(){
        
        // Recieve Packets
        for i in 0..<_incomingPackets.count() {
            do {
                
                // Get packet instance
                let packet = _incomingPackets[i]
                
                // Ack Packets
                if let p = packet as? AckPacket{
                    if packetsWaitingForAck[p.uuid] != nil {
                        packetsWaitingForAck.removeValue(forKey: p.uuid)
                    }
                }
                
                // add to archive
                if let p = packet as? TransformPacket2{
                    PacketArchiver.insertNewTransformpackets(transformPacket: p)
                }
            }
        }
        
        
        // Clear
        _incomingPackets.removeAll()
        
        // Update Packet Archiver
        PacketArchiver.update()
    }
}

// Advertiser Delegate
extension MultipeerController: MCNearbyServiceAdvertiserDelegate {
   
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
    }
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping ((Bool, MCSession?) -> Void)) {
        invitationHandler(true, self.session)
    }
}

// Browser Delegate
extension MultipeerController: MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error){
    }
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?){
        addPeer(peerID: peerID)
    }
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID){
        removePeer( peerID: peerID );
    }
    
    private func addPeer( peerID: MCPeerID ){
        
        if !nearbyPeers.contains(peerID){
            nearbyPeers.append(peerID)
        }
        delegate.peerFound( nearbyPeers: nearbyPeers )
        
        serviceBrowser.invitePeer(peerID, to: session, withContext: nil, timeout: 3)
    }
    private func removePeer( peerID: MCPeerID ){
        var index = -1
        for _ in nearbyPeers{
            index += 1
            if peerID == nearbyPeers[index]{
                break
            }
        }
        if index != -1{
            nearbyPeers.remove(at: index)
        }
    }
}

// Session Delegate
extension MultipeerController : MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        switch state {
        case MCSessionState.notConnected:
            print("not connected")
            break
        case MCSessionState.connecting:
            print("connecting")
            break
        case MCSessionState.connected:
            print("connected")
            break
        }
    }
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID){
        DataUnpacker.unpackPacket(data: data)
    }
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?){
    }
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
}

// Data Unpacket Delegate
extension MultipeerController : DataUnpackerDelegate {
    
    func unpackedAckPacket(ackPacket: AckPacket) {
        addIncomingPacket(packet: ackPacket)
    }
    func unpackedTransformPacket(transformPacket: TransformPacket2) {
         addIncomingPacket(packet: transformPacket)
    }
}

// Session States
extension MCSessionState {
    
    func stringValue() -> String {
        switch(self) {
        case .notConnected: return "NotConnected"
        case .connecting: return "Connecting"
        case .connected: return "Connected"
        }
    }
}


protocol MultipeerControllerDelegate {
    func peerFound( nearbyPeers: [MCPeerID] )
    func peerLost(  nearbyPeers: [MCPeerID] )
    func recieveData()
}



