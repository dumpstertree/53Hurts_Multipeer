//
//  TransformPacket.swift
//  53 Hurts
//
//  Created by Zachary Collins on 2/22/17.
//  Copyright © 2017 dumpstertree. All rights reserved.
//

import Foundation

/*
class TransformPacket: NSObject, NSCoding, Packet{
    
    let uuid: String
    let nodeUuid: String
    let frame : NSNumber
    let x: NSNumber
    let y: NSNumber
    let rotation: NSNumber
    let xScale: NSNumber
    let yScale: NSNumber
    
    init( uuid: String, x: Float, y: Float, rotation: Float, xScale: Float, yScale: Float){
        self.uuid       = UUID().uuidString
        self.nodeUuid   = uuid
        self.frame      = FrameCounter.Frame as NSNumber
        self.x          = x                  as NSNumber
        self.y          = y                  as NSNumber
        self.rotation   = rotation           as NSNumber
        self.xScale     = xScale             as NSNumber
        self.yScale     = yScale             as NSNumber
    }
    required init(coder decoder: NSCoder) {
        self.uuid       = decoder.decodeObject(forKey: "uuid")      as? String   ?? ""
        self.nodeUuid   = decoder.decodeObject(forKey: "nodeUuid")  as? String   ?? ""
        self.frame      = decoder.decodeObject(forKey: "frame")     as? NSNumber ?? -1
        self.x          = decoder.decodeObject(forKey: "x")         as? NSNumber ?? 0
        self.y          = decoder.decodeObject(forKey: "y")         as? NSNumber ?? 0
        self.rotation   = decoder.decodeObject(forKey: "rotation")  as? NSNumber ?? 0
        self.xScale     = decoder.decodeObject(forKey: "xScale")    as? NSNumber ?? 0
        self.yScale     = decoder.decodeObject(forKey: "yScale")    as? NSNumber ?? 0
    }
    
    func encode(with coder: NSCoder) {
        coder.encode( uuid, forKey: "uuid")
        coder.encode( frame, forKey: "frame")
        coder.encode( nodeUuid, forKey: "nodeUuid" )
        coder.encode( x, forKey: "x" )
        coder.encode( y, forKey: "y" )
        coder.encode( rotation, forKey: "rotation" )
        coder.encode( xScale, forKey: "xScale" )
        coder.encode( yScale, forKey: "yScale" )
        
    }
}
*/
struct TransformPacket2: Packet {
    
   
    public var Data:     Data?
    public let uuid:     String
    public let nodeUuid: String
    public let frame :   Int
    public let x:        Float
    public let y:        Float
    public let rotation: Float
    public let xScale:   Float
    public let yScale:   Float
    
    private var _data: [ String: AnyObject ] = [:]
    
    init( uuid: String, x: Float, y: Float, rotation: Float, xScale: Float, yScale: Float){
        
        self.uuid       = UUID().uuidString
        self.nodeUuid   = uuid
        self.frame      = FrameCounter.Frame as Int
        self.x          = x                  as Float
        self.y          = y                  as Float
        self.rotation   = rotation           as Float
        self.xScale     = xScale             as Float
        self.yScale     = yScale             as Float
        
        _data["uuid"]       = self.uuid     as AnyObject?
        _data["node_uuid"]  = self.nodeUuid as AnyObject?
        _data["frame"]      = self.frame    as AnyObject?
        _data["x_position"] = self.x        as AnyObject?
        _data["y_position"] = self.y        as AnyObject?
        _data["rotation"]   = self.rotation as AnyObject?
        _data["x_scale"]    = self.xScale   as AnyObject?
        _data["y_scale"]    = self.yScale   as AnyObject?
        
        do {
            Data = try JSONSerialization.data(withJSONObject: _data, options: .prettyPrinted)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    init( data: [ String : AnyObject ] ){
        
        self._data = data
        
        self.uuid     = _data["uuid"]       as! String
        self.nodeUuid = _data["node_uuid"]  as! String
        self.frame    = _data["frame"]      as! Int
        self.x        = _data["x_position"] as! Float
        self.y        = _data["y_position"] as! Float
        self.rotation = _data["rotation"]   as! Float
        self.xScale   = _data["x_scale"]    as! Float
        self.yScale   = _data["y_scale"]    as! Float
        
        do {
            Data = try JSONSerialization.data(withJSONObject: _data, options: .prettyPrinted)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    static public func decode( data: Data ) -> [String:AnyObject]? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [ String : AnyObject ]
        }
        catch {
            return nil
        }
    }
    
}
