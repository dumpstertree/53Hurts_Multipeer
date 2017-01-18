//
//  MultipeerPlayerData.swift
//  53 Hurts
//
//  Created by Zachary Collins on 1/13/17.
//  Copyright © 2017 dumpstertree. All rights reserved.
//

import Foundation

class PlayerPacket: NSObject, NSCoding {
    
    let id: String
    
    let r: Float
    let g: Float
    let b: Float
    
    init( id: String, r: Float, g: Float, b:Float ){
        self.id = id
        self.r = r
        self.g = g
        self.b = b
    }
    
    required init(coder decoder: NSCoder) {
        self.id = decoder.decodeObject(forKey: "id") as? String ?? ""
        self.r = r
        self.g = g
        self.b = b
    }
    
    func encode(with coder: NSCoder) {
        coder.encode( id, forKey: "id" )
        self.r = r
        self.g = g
        self.b = b
    }
}
