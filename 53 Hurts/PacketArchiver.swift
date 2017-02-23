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
    static public var CurrentPacket : TransformPacket2? {
        get {
            
            if _transformPackets.count < _maxFrameHistory{
                return nil
            }
            guard let packet = _transformPackets[ FrameCounter.Frame - _maxFrameHistory ] else {
               
                let x = FrameCounter.Frame - _maxFrameHistory
                let y = FrameCounter.Frame
                print("No Packet: \(x) / \(y)")
                return nil
            }
            
            return packet
        }
    }
    
    // Instance Variables
    static private var _newTransformPackets: [TransformPacket2] = []
    static private var _transformPackets: [Int: TransformPacket2] = [:]
    static private let _maxFrameHistory = 60
    
    // Public
    static public func insertNewTransformpackets( transformPacket: TransformPacket2 ){
        _newTransformPackets.append(transformPacket)
    }
    static public func update(){
        
        let smallestFrame = FrameCounter.Frame - _maxFrameHistory
        
        // Iterate through all new packets
        for packet in _newTransformPackets{
            
            // If too old throw out
            let frame = packet.frame as Int
            if frame < smallestFrame{
                print("Packet too old, thrown out; FRAME : \(packet.frame)) ")
                continue
            }

            // Add Packet
            _transformPackets[frame] = packet
        }
        
        // Clear new packets
        _newTransformPackets.removeAll()
        
        // Remove old packets
        let keys = _transformPackets.keys.sorted().filter { $0 < smallestFrame }
        for key in keys{
            _transformPackets.removeValue(forKey: key)
        }
    }
}

