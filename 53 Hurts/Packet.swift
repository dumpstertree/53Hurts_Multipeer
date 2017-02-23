//
//  Packet.swift
//  53 Hurts
//
//  Created by Zachary Collins on 1/29/17.
//  Copyright © 2017 dumpstertree. All rights reserved.
//

import Foundation
protocol Packet {
    var uuid: String{ get }
    var frame: Int { get }
}
