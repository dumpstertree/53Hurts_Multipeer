//
//  GameScene.swift
//  53 Hurts
//
//  Created by Zachary Collins on 1/3/17.
//  Copyright © 2017 dumpstertree. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var multipeerController: MultipeerController!
    
    var playerSprites: [MultipeerSKSpriteNode]  = []
    var connectedPlayersSprites: [ String : SKSpriteNode] = [:]
    
    var player : MultipeerSKSpriteNode? = nil
    var connectedPlayer : MultipeerSKSpriteNode? = nil
    
    override func update(_ currentTime: TimeInterval) {
       
        // Increase Frame Count
        FrameCounter.increment()
        
        // Set As Data Unpacker Delegate
        if DataUnpacker.delegate == nil{
            DataUnpacker.delegate = self
        }
        
        // Create  Player
        if player == nil{
            player = MultipeerSKSpriteNode()
            addChild(player!)
        }
        
        // Create Other Player
        if connectedPlayer == nil{
            connectedPlayer = MultipeerSKSpriteNode()
            addChild(connectedPlayer!)
        }
        
        // User Player
        player?.move()
        player?.sendData(multipeerController: multipeerController)
        
        // User Connected Player
        connectedPlayer?.pullData()
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //createNewMultipeerSpriteNode( touch:  touches.first! )
        player?.position = touches.first!.location(in: self)
    }
    
    // Self
    func createNewMultipeerSpriteNode( touch: UITouch ){
        //let sprite = MultipeerSKSpriteNode()
        //sprite.position = touch.location(in: self)
        //playerSprites.append(sprite)
        //addChild(sprite)
    }
    
    // Other Player
    func updateSpriteTransform( transformPacket: TransformPacket ){
        
        /*
       
         guard let sprite = connectedPlayersSprites[transformPacket.uuid] else{
            createNewSpriteNode(transformPacket: transformPacket)
            return
        }
        sprite.position = CGPoint( x: Double(transformPacket.x), y: Double(transformPacket.y) )
         
         */
        
        guard let player = connectedPlayer else{
            createNewSpriteNode(transformPacket: transformPacket)
            return
        }
        
        player.position = CGPoint( x: Double(transformPacket.x), y: Double(transformPacket.y) )

    }
    func createNewSpriteNode( transformPacket: TransformPacket ){
        let newObject = SKSpriteNode(color: UIColor.blue, size: CGSize(width: 100, height: 100))
        newObject.position = CGPoint(x: Double(transformPacket.x), y: Double(transformPacket.y) )
        connectedPlayersSprites[ transformPacket.uuid] = newObject
        addChild(newObject)
    }
}

extension GameScene: DataUnpackerDelegate{
    func unpackedTransformPacket(transformPacket: TransformPacket) {
        updateSpriteTransform(transformPacket: transformPacket)
    }
}
