//
//  FrameCounter.swift
//  53 Hurts
//
//  Created by Zachary Collins on 1/23/17.
//  Copyright © 2017 dumpstertree. All rights reserved.
//

import Foundation
import SpriteKit

class FrameCounter{
    
    static public var Frame : Int {
        get {
            return _frame
        }
    }
    static var _frame: Int = -1
    
    static public func increment() {
        _frame = _frame+1
    }
}
