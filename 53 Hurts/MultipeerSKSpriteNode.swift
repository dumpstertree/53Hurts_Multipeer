//
//  MultipeerSKObject.swift
//  53 Hurts
//
//  Created by Zachary Collins on 1/8/17.
//  Copyright © 2017 dumpstertree. All rights reserved.
//
import SpriteKit
import Foundation

class MultipeerSKSpriteNode: SKSpriteNode {
    
    func sendData( multipeerController: MultipeerController ){
       
        let x         = Float(position.x)
        let y         = Float(position.y)
        let rotation  = Float(zRotation)
        let scale_x   = Float(xScale)
        let scale_y   = Float(yScale)
        
        let transformPacket = TransformPacket(x: x, y: y, rotation: rotation, xScale: scale_x, yScale: scale_y)
        
        print(transformPacket.x)
        multipeerController.pushData( data: transformPacket )
    }
    
}

class TransformPacket: NSObject, NSCoding{
    
    let x: Float
    let y: Float
    let rotation: Float
    let xScale: Float
    let yScale: Float
    
    init( x: Float, y: Float, rotation: Float, xScale: Float, yScale: Float){
        self.x = x
        self.y = y
        self.rotation = rotation
        self.xScale = xScale
        self.yScale = yScale
    }
    
    required init(coder decoder: NSCoder) {
        self.x          = decoder.decodeObject(forKey: "x") as? Float ?? 0
        self.y          = decoder.decodeObject(forKey: "y") as? Float ?? 0
        self.rotation   = decoder.decodeObject(forKey: "rotation") as? Float ?? 0
        self.xScale     = decoder.decodeObject(forKey: "xScale") as? Float ?? 0
        self.yScale     = decoder.decodeObject(forKey: "yScale") as? Float ?? 0
    }
    
    func encode(with coder: NSCoder) {
        coder.encode( x, forKey: "x" )
        coder.encode( y, forKey: "y" )
        coder.encode( rotation, forKey: "rotation" )
        coder.encode( xScale, forKey: "xScale" )
        coder.encode( yScale, forKey: "yScale" )
        
    }
}
