//
//  PacketArchiver.swift
//  53 Hurts
//
//  Created by Zachary Collins on 1/23/17.
//  Copyright © 2017 dumpstertree. All rights reserved.
//

import Foundation

class PacketArchiver{
    
    static public var CurrentPacket : TransformPacket? {
        get {
            
            if _transformPacketsFrames.count-1 < _frameDelay{
                return nil
            }
            let frame = _transformPacketsFrames[ _frameDelay ]
            return  _transformPackets[ frame ]
        }
    }
    static public var NextPacket : TransformPacket? {
        get {
            
            if _transformPacketsFrames.count-1 < _frameDelay+1{
                return nil
            }
            
            let frame = _transformPacketsFrames[ _frameDelay+1 ]
            return _transformPackets[ frame ]
        }
    }
    
    static private var _transformPacketsFrames: [Int] = []
    static private var _transformPackets: [Int: TransformPacket] = [:]
    
    static private let _maxFrameHistory = 10
    static private let _timeBetweenFrames = 0.0333
    static private let _frameDelay = 5
    
    // Public
    static public func addTransformPacket( transformPacket: TransformPacket ){
       
        let frame = transformPacket.frame as Int
        
        // Remove Old Packets
        while _transformPacketsFrames.count > _maxFrameHistory {
            _transformPackets.removeValue(forKey: _transformPacketsFrames.first!)
            _transformPacketsFrames.removeFirst()
        }
        
        // Add New Packet
        if _transformPacketsFrames.count > 0 {
            if frame > _transformPacketsFrames.first!{
                _transformPacketsFrames.append(frame)
                _transformPackets[frame] = transformPacket
            }
        }
        else{
            _transformPacketsFrames.append(frame)
            _transformPackets[frame] = transformPacket
        }

        
        // Sort
        _transformPacketsFrames.sort()
    }
    static public func getTransformPackets() -> TransformInterpolaterPacket{
        let packet = TransformInterpolaterPacket()
        return packet
    }
}

public struct TransformInterpolaterPacket{
    
    let currentPacket: TransformPacket?
    let targetPacket: TransformPacket?
    let frameDistance: Int
    
    init() {
        
        currentPacket = PacketArchiver.CurrentPacket
        targetPacket  = PacketArchiver.NextPacket
        
        if let cur = currentPacket,  let tar = targetPacket {
            let curFrame = cur.frame as Int
            let tarFrame = tar.frame as Int
            frameDistance = abs( curFrame - tarFrame )
        }
        else{
            frameDistance = -1
        }
    }
}
