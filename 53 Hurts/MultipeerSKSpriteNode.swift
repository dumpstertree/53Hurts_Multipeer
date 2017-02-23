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
        
        let transformPacket = TransformPacket2( uuid: uuid, x: x, y: y, rotation: rotation, xScale: scale_x, yScale: scale_y)
        
        multipeerController.addOutgoingPacket(packet: transformPacket )
    }
    func pullData(){
        
        let packet = PacketArchiver.CurrentPacket
        
        guard let p = packet as TransformPacket2! else {
            return
        }
        
        position = CGPoint( x: Double(p.x), y: Double(p.y) )
    }
    func move(){
        let offset: CGFloat = 1.0
        position = CGPoint(x: position.x, y: position.y+offset)
    }
}
