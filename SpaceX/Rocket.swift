//
//  Rocket.swift
//  SpaceX
//
//  Created by Chris Scheid on 3/4/18.
//  Copyright © 2018 Chris Scheid. All rights reserved.
//

import Foundation

class Rocket: CustomStringConvertible{
    var name: String = ""
    
    // to string
    var description: String {
        let desc =
            "Summary: \(summary)\n\n" +
            "Active: \(active)\n" +
            "Stages: \(stages)\n" +
            "Boosters: \(boosters)\n" +
            "Cost Per Launch: \(cost_per_launch)\n" +
            "Success Rate: \(success_rate_pct)\n" +
            "First Flight: \(first_flight)\n" +
            "Country: \(country)\n" +
            "Height: \(height)\n" +
            "Diameter: \(diameter)\n" +
            "Mass: \(mass)\n" +
            "Payload Weights: \(payload_weights)\n" +
            "First Stage: \(first_stage)\n" +
            "Second Stage: \(second_stage)\n" +
            "Landing Legs: \(landing_legs)\n"
        
        return desc
    }
    
    // Properties
    var id: String = ""
    var title: String = ""
    var summary: String = ""
    var active: Bool = true
    var stages: Int = 0
    var boosters: Int = 0
    var cost_per_launch: Int = 0
    var success_rate_pct: Int = 0
    var first_flight: String = ""
    var country: String = ""
    var height: String = ""
    var diameter: String = ""
    var mass: String = ""
    var payload_weights: String = ""
    var first_stage: String = ""
    var second_stage: String = ""
    var engines : String = ""
    var landing_legs: String = ""
}

