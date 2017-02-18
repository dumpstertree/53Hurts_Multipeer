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
    
    let uuid: String
    private var _lastFrame = 0
    private var _frameInterp = 0

    init() {
        self.uuid = UUID().uuidString
        super.init(texture: nil, color: UIColor.red, size: CGSize(width: 100, height: 100))
    }
    required init?(coder aDecoder: NSCoder) {
        self.uuid = UUID().uuidString
        super.init(coder: aDecoder)
    }
    
    func sendData( multipeerController: MultipeerController ){
        let x         = Float(position.x)
        let y         = Float(position.y)
        let rotation  = Float(zRotation)
        let scale_x   = Float(xScale)
        let scale_y   = Float(yScale)
        
        let transformPacket = TransformPacket( uuid: uuid, x: x, y: y, rotation: rotation, xScale: scale_x, yScale: scale_y)
        
        multipeerController.pushData( data: transformPacket )
    }
    func pullData(){
        
        let packet = PacketArchiver.CurrentPacket
        
        guard let p = packet as TransformPacket! else {
            return
        }
        
        position = CGPoint( x: Double(p.x), y: Double(p.y) )
    }
    func move(){
        let offset: CGFloat = 1.0
        position = CGPoint(x: position.x, y: position.y+offset)
    }
}

class TransformPacket: NSObject, NSCoding, Packet{
    
    let uuid: String
    let nodeUuid: String
    let frame : NSNumber
    let x: NSNumber
    let y: NSNumber
    let rotation: NSNumber
    let xScale: NSNumber
    let yScale: NSNumber
    
    init( uuid: String, x: Float, y: Float, rotation: Float, xScale: Float, yScale: Float){
        self.uuid       = UUID().uuidString
        self.nodeUuid   = uuid
        self.frame      = FrameCounter.Frame as NSNumber
        self.x          = x                  as NSNumber
        self.y          = y                  as NSNumber
        self.rotation   = rotation           as NSNumber
        self.xScale     = xScale             as NSNumber
        self.yScale     = yScale             as NSNumber
    }
    required init(coder decoder: NSCoder) {
        self.uuid       = decoder.decodeObject(forKey: "uuid")      as? String   ?? ""
        self.nodeUuid   = decoder.decodeObject(forKey: "nodeUuid")  as? String   ?? ""
        self.frame      = decoder.decodeObject(forKey: "frame")     as? NSNumber ?? -1
        self.x          = decoder.decodeObject(forKey: "x")         as? NSNumber ?? 0
        self.y          = decoder.decodeObject(forKey: "y")         as? NSNumber ?? 0
        self.rotation   = decoder.decodeObject(forKey: "rotation")  as? NSNumber ?? 0
        self.xScale     = decoder.decodeObject(forKey: "xScale")    as? NSNumber ?? 0
        self.yScale     = decoder.decodeObject(forKey: "yScale")    as? NSNumber ?? 0
    }
    
    func encode(with coder: NSCoder) {
        coder.encode( uuid, forKey: "uuid")
        coder.encode( frame, forKey: "frame")
        coder.encode( nodeUuid, forKey: "nodeUuid" )
        coder.encode( x, forKey: "x" )
        coder.encode( y, forKey: "y" )
        coder.encode( rotation, forKey: "rotation" )
        coder.encode( xScale, forKey: "xScale" )
        coder.encode( yScale, forKey: "yScale" )
        
    }
}


public func lerp( a: Float, b: Float, t: Float ) -> Float {
      return a + (b - a) * t;
}
