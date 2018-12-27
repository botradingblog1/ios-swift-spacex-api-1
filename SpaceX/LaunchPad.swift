//
//  LaunchPad.swift
//  SpaceX
//
//  Created by Chris Scheid on 3/5/18.
//  Copyright © 2018 Chris Scheid. All rights reserved.
//

import Foundation

class LaunchPad: CustomStringConvertible{
    var name: String = ""
    
    // to string
    var description: String {
        let desc =
            "Details: \(details)\n\n" +
            "Status: \(status)\n" +
            "Location Name: \(location_name)\n" +
            "Region: \(region)\n" 
        
        return desc
    }
    
    // Properties
    var id: String = ""
    var full_name: String = ""
    var details: String = ""
    var status: String = ""
    var location_name: String = ""
    var region: String = ""
    var latitude: String = ""
    var longitude: String = ""
}
