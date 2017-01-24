//
//  Player.swift
//  53 Hurts
//
//  Created by Zachary Collins on 1/21/17.
//  Copyright © 2017 dumpstertree. All rights reserved.
//

import Foundation
import SpriteKit

class Player{
    
    let sprite: MultipeerSKSpriteNode
    let speed: CGFloat = 5.0
   
    init() {
        sprite = MultipeerSKSpriteNode()
    }
    
    public func recieveInput( input: InputType ){
        
        switch input {
        case .LEFT:
            moveLeft()
            break
        case .RIGHT:
            moveRight()
            break
        case .UP:
            moveUp()
            break
        case .DOWN:
            moveDown()
            break
        }
    }
    
    private func moveLeft(){
        sprite.position.x = sprite.position.x-speed
    }
    private func moveRight(){
         sprite.position.x = sprite.position.x+speed
    }
    private func moveUp(){
         sprite.position.y = sprite.position.y+speed
    }
    private func moveDown(){
         sprite.position.y = sprite.position.y-speed
    }
}

 enum InputType{
    case LEFT
    case RIGHT
    case UP
    case DOWN
}
