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
    
    var packetsWaitingForAck : [ String : TransformPacket] = [:]
    var packetResendTime = 10
    
    var incomingPackets: [Packet] = []
    var outgoingPackets: [Packet] = []
    
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
    public func pushData( data: Packet ){
        
        // If not connected; ABORT
        if session.connectedPeers.count == 0{
            return
        }
        
        do {
            // Try to send Data
            let convertedData = NSKeyedArchiver.archivedData(withRootObject: data)
            try session.send( convertedData, toPeers: session.connectedPeers, with: MCSessionSendDataMode.reliable)
           
            // If not already in list; add it
            if let p = data as? TransformPacket{
                if packetsWaitingForAck[p.uuid] == nil {
                    packetsWaitingForAck[p.uuid] = p
                }
            }
        }
        catch{
            print("could not convert")
        }
    }
    public func resendPackets(){
        
        for packet in packetsWaitingForAck{
            let packetFrame = packet.value.frame as Int
            if ( (FrameCounter.Frame-packetFrame) % packetResendTime) == 0 {
                pushData(data: packet.value)
                print("RESENT : \(packet.value.frame)")
            }
        }
    }

    public func push(){
    
    }
    
    public func pull(){
        
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
        
        delegate.peerFound( nearbyPeers: nearbyPeers )
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
        //incomingPackets.append(ackPacket)
        packetsWaitingForAck.removeValue(forKey: ackPacket.uuid )
    }
    func unpackedTransformPacket(transformPacket: TransformPacket) {
        pushData(data: AckPacket(uuid: transformPacket.uuid ))
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



