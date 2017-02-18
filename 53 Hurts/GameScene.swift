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
    
    var player : MultipeerSKSpriteNode? = nil
    var connectedPlayer : MultipeerSKSpriteNode? = nil
    
    // Ovveride
    override func update(_ currentTime: TimeInterval) {
       
        if multipeerController.session.connectedPeers.count > 0{
            // Increase Frame Count
            FrameCounter.increment()
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
        
        // Cleanup old packets
        PacketArchiver.refresh()
        
        // Resend Data
        multipeerController.resendPackets()
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        player?.position = touches.first!.location(in: self)
    }
}
