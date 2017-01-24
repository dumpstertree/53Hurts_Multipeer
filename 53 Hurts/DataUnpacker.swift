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
    
    public static var delegate: DataUnpackerDelegate?
    
    public static func unpackPacket( data: Data ){
    
        if let transformPacket = NSKeyedUnarchiver.unarchiveObject(with: data) as? TransformPacket {
            DataUnpacker.unpackTransformPacket( transformPacket: transformPacket )
            return
        }
    }
    
    private static func unpackTransformPacket( transformPacket: TransformPacket ){
        //delegate?.unpackedTransformPacket(transformPacket: transformPacket)
        PacketArchiver.addTransformPacket(transformPacket: transformPacket )
    }
    private static func unpackInputPacket(){
         // Delegate.UnpackedPacket
    }
    
    private static func unpackPlayerPacket( packet: PlayerPacket ){
        // Delegate.UnpackedPacket
    }
}


protocol DataUnpackerDelegate {
    func unpackedTransformPacket( transformPacket: TransformPacket )
}
