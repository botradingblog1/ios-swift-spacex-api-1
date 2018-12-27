//
//  Company.swift
//  SpaceX
//
//  Created by Chris Scheid on 3/4/18.
//  Copyright © 2018 Chris Scheid. All rights reserved.
//

import Foundation

class Company: CustomStringConvertible{
    var title: String = ""
    
    // to string
    var description: String {
        let desc =
        "Summary: \(summary)\n\n" +
        "Founder: \(founder)\n" +
        "Employees: \(employees)\n" +
        "Vehicles: \(vehicles)\n" +
        "Launch Sites: \(launch_sites)\n" +
        "Test Sites: \(test_sites)\n" +
        "CEO: \(ceo)\n" +
        "CTO: \(ceo)\n" +
        "COO: \(coo)\n" +
        "CTO Propulsion: \(cto_propulsion)\n"
        
        return desc
    }
    
    // Properties
    var founder: String = ""
    var employees: Int = 0
    var vehicles: Int = 0
    var launch_sites: Int = 0
    var test_sites: Int = 0
    var ceo: String = ""
    var cto: String = ""
    var coo: String = ""
    var cto_propulsion: String = ""
    var summary: String = ""
}

