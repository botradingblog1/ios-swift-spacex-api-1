//
//  Launch.swift
//  SpaceX
//
//  Created by Chris Scheid on 3/4/18.
//  Copyright © 2018 Chris Scheid. All rights reserved.
//

import Foundation


class Launch: CustomStringConvertible{
    var name: String = ""
    
    // to string
    var description: String {
        let desc =
                "Details: \(details)\n" +
                "Launch Date: \(launch_date_utc)\n" +
                "Rocket: \(rocket)\n" +
                "Launch Site: \(launch_site)\n" +
                "Links: \n\(links)\n"
        
        return desc
    }
    
    // Properties
    var flight_number: Int = 0
    var details: String = ""
    var launch_date_utc: String = ""
    var rocket: String = ""
    var launch_site: String = ""
    var launch_success: Bool = false
    var links: String = ""
    
}
