//
//  Utils.swift
//  SpaceX
//
//  Created by Chris Scheid on 3/4/18.
//  Copyright © 2018 Chris Scheid. All rights reserved.
//

import Foundation

class Utils{
    static func getUniqueId() -> Int32{
        // Get current date
        let someDate = Date()
        
        // Convert Date to TimeInterval (typealias for Double)
        let timeInterval = someDate.timeIntervalSince1970
        
        let uniqueId = timeInterval
        
        return Int32(uniqueId)
    }
    
    static func deepUnwrap(any: Any) -> Any? {
        let mirror = Mirror(reflecting: any)
        
        if mirror.displayStyle == Mirror.DisplayStyle.optional {
            return any
        }
        
        if let child = mirror.children.first {
            return deepUnwrap(any: child.value)
        }
        
        return nil
    }
}
