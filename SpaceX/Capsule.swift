//
//  Capsule.swift
//  SpaceX
//
//  Created by Chris Scheid on 3/4/18.
//  Copyright © 2018 Chris Scheid. All rights reserved.
//

import Foundation

class Capsule: CustomStringConvertible{
    var name: String = ""
    
    // to string
    var description: String {
        let desc =
                "Active: \(active)\n" +
                "Crew Capacity: \(crew_capacity)\n" +
                "Sidewall Angle: \(sidewall_angle_deg)\n" +
                "Orbit Duration (yr): \(orbit_duration_yr)\n" +
                "Heat Shield: \(heat_shield)\n" +
                "Thrusters: \(thrusters)\n" +
                "Launch Payload Mass: \(launch_payload_mass)\n" +
                "Launch Payload Volume: \(launch_payload_vol)\n" +
                "Return Payload Mass: \(return_payload_mass)\n" +
                "Return Payload Volume: \(return_payload_vol)\n" +
                "Pressurized Capsule: \(pressurized_capsule)\n" +
                "Trunk: \(trunk)\n" +
                "Height with trunk: \(height_w_trunk)\n" +
                "Diameter: \(diameter)\n"
        
        return desc
    }
    
    // Properties
    var id: String = ""
    var title: String = ""
    var active: Bool = true
    var crew_capacity: Int = 0
    var sidewall_angle_deg: Int = 0
    var orbit_duration_yr: Int = 0
    var heat_shield: String = ""
    var thrusters: String = ""
    var launch_payload_mass: String = ""
    var launch_payload_vol: String = ""
    var return_payload_mass: String = ""
    var return_payload_vol: String = ""
    var pressurized_capsule: String = ""
    var trunk: String = ""
    var height_w_trunk: String = ""
    var diameter: String = ""

  }
