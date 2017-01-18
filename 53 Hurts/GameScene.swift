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
    
    var sprites: [MultipeerSKSpriteNode] = []
    
    
    override func update(_ currentTime: TimeInterval) {
        /*for sprite in sprites{
            sprite.sendData(multipeerController: multipeerController)
        }*/
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let newObject = MultipeerSKSpriteNode(imageNamed: "Spaceship")
        newObject.position = (touches.first?.location(in: self))!
        addChild(newObject)
        sprites.append(newObject)
    }
}
