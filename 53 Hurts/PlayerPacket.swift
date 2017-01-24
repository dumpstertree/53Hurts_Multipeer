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
    let skin: NSInteger
    
    init( id: String, skin: NSInteger ){
        self.id = id
        self.skin = skin
    }
    
    required init(coder decoder: NSCoder) {
        self.id = decoder.decodeObject(forKey: "id") as? String ?? ""
        self.skin = decoder.decodeObject(forKey: "skin") as? NSInteger ?? -1
    }
    
    func encode(with coder: NSCoder) {
        coder.encode( id, forKey: "id" )
         coder.encode( skin, forKey: "skin" )
    }
}
