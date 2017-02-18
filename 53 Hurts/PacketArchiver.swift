//
//  PacketArchiver.swift
//  53 Hurts
//
//  Created by Zachary Collins on 1/23/17.
//  Copyright © 2017 dumpstertree. All rights reserved.
//

import Foundation

class PacketArchiver{
    
    // Properties
    static public var CurrentPacket : TransformPacket? {
        get {
            
            if _transformPackets.count < _maxFrameHistory{
                return nil
            }
            guard let packet = _transformPackets[ FrameCounter.Frame - _maxFrameHistory ] else {
               
                let x = FrameCounter.Frame - _maxFrameHistory
                let y = FrameCounter.Frame
                //let key = _transformPackets.keys.sorted()
                
                print("No Packet: \(x) / \(y)")
                return nil
            }
            
            return  packet
        }
    }
    
    // Instance Variables
    static private var _newTransformPackets: [TransformPacket] = []
    static private var _ackedTransformPackets: [AckPacket] = []
    static private var _transformPackets: [Int: TransformPacket] = [:]
    static private let _maxFrameHistory = 60
    
    // Public
    static public func insertNewTransformpackets( transformPacket: TransformPacket ){
        _newTransformPackets.append(transformPacket)
    }
    static public func ackTransformPacket( ackPacket: AckPacket ){
        _ackedTransformPackets.append(ackPacket)
    }
    static public func refresh(){
        
        // Iterate through all new packets
        for packet in _newTransformPackets{
            
            let frame = packet.frame as Int
            let smallestFrame = FrameCounter.Frame - _maxFrameHistory
            
            // If too old dont store
            if frame < smallestFrame{
                print("Packet too old, thrown out; FRAME : \(packet.frame)) ")
                return
            }
            
            // Add Packet
            _transformPackets[frame] = packet
        }
        
        // Clear new packets
        _newTransformPackets = []
        
        // Remove Old Keys
        let smallestFrame = FrameCounter.Frame - _maxFrameHistory
        let keys = _transformPackets.keys.sorted().filter { $0 < smallestFrame }
        for key in keys{
            _transformPackets.removeValue(forKey: key)
        }
    }
}

