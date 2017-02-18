//
//  AckPackage.swift
//  53 Hurts
//
//  Created by Zachary Collins on 1/29/17.
//  Copyright © 2017 dumpstertree. All rights reserved.
//

import Foundation

class AckPacket: NSObject, NSCoding, Packet{
    
    let uuid: String
    
    init( uuid: String ){
        self.uuid = uuid
    }
    required init(coder decoder: NSCoder) {
        self.uuid = decoder.decodeObject(forKey: "uuid") as? String   ?? ""
    }
    func encode(with coder: NSCoder) {
        coder.encode( uuid, forKey: "uuid")
    }
}
