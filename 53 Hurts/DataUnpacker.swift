//
//  DataUnpacker.swift
//  53 Hurts
//
//  Created by Zachary Collins on 1/17/17.
//  Copyright © 2017 dumpstertree. All rights reserved.
//

import Foundation
import SpriteKit

class DataUnpacker{
    
    public static var delegates: [DataUnpackerDelegate] = []
    
    public static func unpackPacket( data: Data ){
    
        if let transformPacket = NSKeyedUnarchiver.unarchiveObject(with: data) as? TransformPacket {
            checkFrame(packet: transformPacket)
            DataUnpacker.unpackTransformPacket( transformPacket: transformPacket )
            return
        }
        
        if let ackPacket = NSKeyedUnarchiver.unarchiveObject(with: data) as? AckPacket {
            DataUnpacker.unpackAckPacket( ackPacket: ackPacket )
            return
        }
    }
    
    // ACK PACKET
    private static func unpackAckPacket( ackPacket: AckPacket ){
        for delegate in delegates{
            delegate.unpackedAckPacket( ackPacket: ackPacket )
        }
    }
    
    // TRANSFORM PACKET
    private static func unpackTransformPacket( transformPacket: TransformPacket ){
        
        PacketArchiver.insertNewTransformpackets(transformPacket: transformPacket)
        
        for delegate in delegates{
            delegate.unpackedTransformPacket(transformPacket: transformPacket)
        }
    }
    
    private static func checkFrame( packet: TransformPacket ){
        if packet.frame as Int > FrameCounter.Frame{
            FrameCounter.set(frame: packet.frame as Int)
        }
    }
}


protocol DataUnpackerDelegate {
    func unpackedTransformPacket( transformPacket: TransformPacket )
    func unpackedAckPacket( ackPacket: AckPacket )
}
