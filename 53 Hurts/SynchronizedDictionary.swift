//
//  SynchronizedDictionary.swift
//  53 Hurts
//
//  Created by Zachary Collins on 2/22/17.
//  Copyright © 2017 dumpstertree. All rights reserved.
//

/*
import Foundation
public class SynchronizedDictionary<Key: Hashable, Value: Hashable> {
    private var dictionary: [Key:Value] = [:]
    private let accessQueue = DispatchQueue(label: "SynchronizedArrayAccess", attributes: .concurrent)

    public subscript(key: Key)->Value? {
        get {
            
            var element: Hashable
            self.accessQueue.sync {
                element = self.dictionary[key]
            }
            
            return element
        }
        set {
            self.accessQueue.async(flags:.barrier) {
                self.dictionary[key] = newValue
            }
        }
    }
}*/
