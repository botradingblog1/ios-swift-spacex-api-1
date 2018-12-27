//
//  SpaceXApiClient.swift
//  SpaceX
//
//  Created by Chris Scheid on 3/3/18.
//  Copyright © 2018 Chris Scheid. All rights reserved.
//

import Foundation

import UIKit

class SpaceXApiClient: NSObject {
    public static func getCompanyInfo(completion: @escaping(_ company: Company?, _ error: String?) -> Void) {
        
        let company = Company()
        
        let urlString = SpaceXApiConstants.SpaceXURLs.APIBaseURL + SpaceXApiConstants.SpaceXMethods.company
        print("SpaceX Url: "+urlString)
        
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.timeoutInterval = TimeInterval(SpaceXApiConstants.SpaceXNetConfig.TimeoutInterval)
        
        // create network request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                completion(nil, "Network error. Please check your network connection.")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completion(nil, "Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                completion(nil, "No data was returned by the request!")
                return
            }
            
            // parse the data
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            } catch {
                completion(nil, "Could not parse the data as JSON:\n'\(data)'")
                return
            }
            
            
            /* GUARD: Get all keys */
            if let title = parsedResult["name"] as? String{
                company.title = title
            }
            if let summary = parsedResult["summary"] as? String{
                company.summary = summary
            }
            if let founder = parsedResult["founder"] as? String{
                company.founder = founder
            }
            if let employees = parsedResult["employees"] as? Int{
                company.employees = employees
            }
            if let vehicles = parsedResult["vehicles"] as? Int{
                company.vehicles = vehicles
            }
            if let launch_sites = parsedResult["launch_sites"] as? Int{
                company.launch_sites = launch_sites
            }
            if let test_sites = parsedResult["test_sites"] as? Int{
                company.test_sites = test_sites
            }
            if let cto = parsedResult["cto"] as? String{
                company.cto = cto
            }
            if let coo = parsedResult["coo"] as? String{
                company.coo = coo
            }
            if let cto_propulsion = parsedResult["cto_propulsion"] as? String{
                company.cto_propulsion = cto_propulsion
            }

            completion(company, "")
        }
        
        task.resume()
        
    }
    
    
    public static func getRockets(completion: @escaping(_ rockets: [Rocket]?, _ error: String?) -> Void) {
        
        var rockets = [Rocket]()
        
        let urlString = SpaceXApiConstants.SpaceXURLs.APIBaseURL + SpaceXApiConstants.SpaceXMethods.rockets
        print("SpaceX Url: "+urlString)
        
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.timeoutInterval = TimeInterval(SpaceXApiConstants.SpaceXNetConfig.TimeoutInterval)
        
        // create network request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                completion(nil, "Network error. Please check your network connection.")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completion(nil, "Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                completion(nil, "No data was returned by the request!")
                return
            }
            
            // parse the data
            let parsedResult: [AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [AnyObject]
            } catch {
                completion(nil, "Could not parse the data as JSON: '\(data)'")
                return
            }
            
            
            // Loop rockets
            for object in parsedResult {
                guard let name = object["name"] as? String,
                    let summary = object["description"] as? String,
                    let active = object["active"] as? Bool,
                    let stages = object["stages"] as? Int,
                    let boosters = object["boosters"] as? Int,
                    let cost_per_launch = object["cost_per_launch"] as? Int,
                    let success_rate_pct = object["success_rate_pct"] as? Int,
                    let first_flight = object["first_flight"] as? String,
                    let country = object["country"] as? String
                    else {
                        completion(nil, "Cannot find keys in \(parsedResult)")
                        return
                }
                let height_obj = object["height"] as AnyObject!
                let diameter_obj = object["diameter"] as AnyObject!
                let mass_obj = object["diameter"] as AnyObject!
                let payload_obj = object["payload_weights"] as! [AnyObject]
                let first_stage_obj = object["first_stage"] as AnyObject!
                let second_stage_obj = object["second_stage"] as AnyObject!
                let engines_obj = object["engines"] as AnyObject!
                let landing_legs_obj = object["landing_legs"] as AnyObject!
                
                let rocket = Rocket()
                rocket.name = name
                rocket.summary = summary
                rocket.active = active
                rocket.stages = stages
                rocket.boosters = boosters
                rocket.cost_per_launch = cost_per_launch
                rocket.success_rate_pct = success_rate_pct
                rocket.first_flight = first_flight
                rocket.country = country
                
                guard let height_meters = height_obj?["meters"] as? Double,
                    let height_feet = height_obj?["feet"] as? Double
                    else {
                        completion(nil, "Cannot find keys in \(parsedResult)")
                        return
                }
                rocket.height = "height meters: \(height_meters), feet: \(height_feet)"
                
                guard let diameter_meters = diameter_obj?["meters"] as? Double,
                    let diameter_feet = diameter_obj?["feet"] as? Double
                    else {
                        completion(nil, "Cannot find keys in \(parsedResult)")
                        return
                }
                rocket.diameter = "diameter meters: \(diameter_meters), feet: \(diameter_feet)"
                
                guard let mass_meters = mass_obj?["meters"] as? Double,
                    let mass_feet = mass_obj?["feet"] as? Double
                    else {
                        completion(nil, "Cannot find keys in \(parsedResult)")
                        return
                }
                rocket.mass = "mass meters: \(mass_meters), feet: \(mass_feet)"
                
                var payload_weigths = ""
                for object in payload_obj {
                    guard let payload_lb = object["lb"] as? Double,
                        let payload_kg = object["kg"] as? Double
                        else {
                            completion(nil, "Cannot find keys in \(parsedResult)")
                            return
                    }
                    payload_weigths = payload_weigths + "payload weights lb: \(payload_lb), feet: \(payload_kg)\n"
                }
                rocket.payload_weights = payload_weigths
                
                
                guard let reusable1 = first_stage_obj?["reusable"] as? Bool,
                    let engines1 = first_stage_obj?["engines"] as? Int,
                    let fuel_amount_tons1 = first_stage_obj?["fuel_amount_tons"] as? Double,
                    let burn_time_sec1 = first_stage_obj?["burn_time_sec"] as? Double
                    else {
                        completion(nil, "Cannot find keys in \(parsedResult)")
                        return
                }
                rocket.first_stage = "reusable: \(reusable1)\n  engines:\(engines1)\n  fuel amount tons: \(fuel_amount_tons1)\n  burn time sec: \(burn_time_sec1)\n"
                

                guard
                    let engines2 = second_stage_obj?["engines"] as? Int,
                    //let fuel_amount_tons2 = second_stage_obj?["fuel_amount_tons"] as? Double,
                    let burn_time_sec2 = second_stage_obj?["burn_time_sec"] as? Double
                    else {
                        completion(nil, "Cannot find keys in \(parsedResult)")
                        return
                }
                rocket.second_stage = "engines:\(engines2)\n  burn time sec: \(burn_time_sec2)\n"
                
      
                guard let eng_number = engines_obj?["number"] as? Int,
                    let eng_type = engines_obj?["type"] as? String,
                    let eng_version = engines_obj?["version"] as? String,
                    let eng_layout = engines_obj?["layout"] as? String,
                    let eng_loss_max = engines_obj?["engine_loss_max"] as? Int,
                    let eng_propellant_1 = engines_obj?["propellant_1"] as? String,
                    let eng_propellant_2 = engines_obj?["propellant_2"] as? String,
                    let eng_thrust_to_weight = engines_obj?["thrust_to_weight"] as? Double
                    else {
                        completion(nil, "Cannot find keys in \(parsedResult)")
                        return
                }
                rocket.engines = "engines: \n  number: \(eng_number)\n  type:\(eng_type)\n  version: \(eng_version)\n  layout: \(eng_layout)\n  loss max: \(eng_loss_max)\n  propellant 1: \(eng_propellant_1)\n  propellant 2: \(eng_propellant_2)\n  thrust to weight: \(eng_thrust_to_weight)"
            
                
                guard let landing_legs_number = landing_legs_obj?["number"] as? Int
                    else {
                        completion(nil, "Cannot find keys in \(parsedResult)")
                        return
                }
                rocket.landing_legs = "number: \(landing_legs_number)\n"
                
                
                rockets.append(rocket)
                
            }

            
            completion(rockets, "")
        }
        
        task.resume()
        
    }
    
    public static func getCapsules(completion: @escaping(_ capsules: [Capsule]?, _ error: String?) -> Void) {
        
        var capsules = [Capsule]()
        
        let urlString = SpaceXApiConstants.SpaceXURLs.APIBaseURL + SpaceXApiConstants.SpaceXMethods.capsules
        print("SpaceX Url: "+urlString)
        
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.timeoutInterval = TimeInterval(SpaceXApiConstants.SpaceXNetConfig.TimeoutInterval)
        
        // create network request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                completion(nil, "Network error. Please check your network connection.")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completion(nil, "Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                completion(nil, "No data was returned by the request!")
                return
            }
            
            // parse the data
            let parsedResult: [AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [AnyObject]
            } catch {
                completion(nil, "Could not parse the data as JSON: '\(data)'")
                return
            }
            
            
            // Loop rockets
            for object in parsedResult {
                guard let name = object["name"] as? String,
                    let active = object["active"] as? Bool,
                    let crew_capacity = object["crew_capacity"] as? Int,
                    let sidewall_angle_deg = object["sidewall_angle_deg"] as? Int,
                    let orbit_duration_yr = object["orbit_duration_yr"] as? Int
                    else {
                        completion(nil, "Cannot find keys in \(parsedResult)")
                        return
                }
                let heat_shield_obj = object["heat_shield"] as AnyObject!
                let thrusters_obj = object["thrusters"] as! [AnyObject]
                let launch_payload_mass_obj = object["launch_payload_mass"] as AnyObject!
                let launch_payload_vol_obj = object["launch_payload_vol"] as AnyObject!
                let return_payload_mass_obj = object["return_payload_mass"] as AnyObject!
                let return_payload_vol_obj = object["return_payload_vol"] as AnyObject!
                let pressurized_capsule_obj = object["pressurized_capsule"] as AnyObject!
                let trunk_obj = object["trunk"] as AnyObject!
                let height_w_trunk_obj = object["height_w_trunk"] as AnyObject!
                let diameter_obj = object["diameter"] as AnyObject!
                
                let capsule = Capsule()
                capsule.name = name
                capsule.active = active
                capsule.sidewall_angle_deg = sidewall_angle_deg
                capsule.crew_capacity = crew_capacity
                capsule.orbit_duration_yr = orbit_duration_yr
                
                guard let heat_shield_material = heat_shield_obj?["material"] as? String,
                    let heat_shield_size_meters = heat_shield_obj?["size_meters"] as? Double,
                    let heat_shield_temp_degrees = heat_shield_obj?["temp_degrees"] as? Double
                    else {
                        completion(nil, "Cannot find keys in \(parsedResult)")
                        return
                }
                capsule.heat_shield = "material: \(heat_shield_material), size meters: \(heat_shield_size_meters), temp degrees: \(heat_shield_temp_degrees)"
                
                var thrusters = ""
                for object in thrusters_obj {
                    guard let thrusters_type = object["type"] as? String,
                        let thrusters_amount = object["amount"] as? Int,
                        let thrusters_pods = object["pods"] as? Int,
                        let thrusters_fuel_1 = object["fuel_1"] as? String,
                        let thrusters_fuel_2 = object["fuel_2"] as? String
                        else {
                            completion(nil, "Cannot find keys in \(parsedResult)")
                            return
                    }
                    thrusters = thrusters + "  type: \(thrusters_type)\n  amount: \(thrusters_amount)\n  pods: \(thrusters_pods)\n  fuel 1: \(thrusters_fuel_1)\n  fuel 2: \(thrusters_fuel_2)"
                }
                capsule.thrusters = thrusters
                
                guard let launch_payload_mass_lb = launch_payload_mass_obj?["lb"] as? Double,
                    let launch_payload_mass_kg = launch_payload_mass_obj?["kg"] as? Double
                    else {
                        completion(nil, "Cannot find keys in \(parsedResult)")
                        return
                }
                capsule.launch_payload_mass = "lb: \(launch_payload_mass_lb), kg: \(launch_payload_mass_kg)"
                
                guard let launch_payload_vol_cubic_meters = launch_payload_vol_obj?["cubic_meters"] as? Double,
                    let launch_payload_vol_cubic_feet = launch_payload_vol_obj?["cubic_feet"] as? Double
                    else {
                        completion(nil, "Cannot find keys in \(parsedResult)")
                        return
                }
                capsule.launch_payload_vol = "cubic meters: \(launch_payload_vol_cubic_meters), cubic feet: \(launch_payload_vol_cubic_feet)"
         
                guard let return_payload_mass_lb = return_payload_mass_obj?["lb"] as? Double,
                    let return_payload_mass_kg = return_payload_mass_obj?["kg"] as? Double
                    else {
                        completion(nil, "Cannot find keys in \(parsedResult)")
                        return
                }
                capsule.return_payload_mass = "lb: \(return_payload_mass_lb), kg: \(return_payload_mass_kg)"
                
                guard let return_payload_vol_cubic_meters = return_payload_vol_obj?["cubic_meters"] as? Double,
                    let return_payload_vol_cubic_feet = return_payload_vol_obj?["cubic_feet"] as? Double
                    else {
                        completion(nil, "Cannot find keys in \(parsedResult)")
                        return
                }
                capsule.return_payload_vol = "cubic meters: \(return_payload_vol_cubic_meters), cubic feet: \(return_payload_vol_cubic_feet)"
                
                guard let diameter_meters = diameter_obj?["meters"] as? Double,
                    let diameter_feet = diameter_obj?["feet"] as? Double
                    else {
                        completion(nil, "Cannot find keys in \(parsedResult)")
                        return
                }
                capsule.diameter = "meters: \(diameter_meters), feet: \(diameter_feet)"
                
                guard let height_w_trunk_meters = height_w_trunk_obj?["meters"] as? Double,
                    let height_w_trunk_feet = height_w_trunk_obj?["feet"] as? Double
                    else {
                        completion(nil, "Cannot find keys in \(parsedResult)")
                        return
                }
                capsule.height_w_trunk = "meters: \(height_w_trunk_meters), feet: \(height_w_trunk_feet)"
                
                let trunk_volume = trunk_obj?["trunk_volume"] as? AnyObject
                guard let trunk_volume_meters = trunk_volume?["cubic_meters"] as? Double,
                    let trunk_volume_feet = trunk_volume?["cubic_feet"] as? Double
                    else {
                        completion(nil, "Cannot find keys in \(parsedResult)")
                        return
                }
                capsule.trunk = "cubic meters: \(trunk_volume_meters), cubic feet: \(trunk_volume_feet)"
                
                capsules.append(capsule)
                
            }
            
            completion(capsules, "")
        }
        
        task.resume()
        
    }
    
    
    public static func getLaunches(completion: @escaping(_ launches: [Launch]?, _ error: String?) -> Void) {
        
        var launches = [Launch]()
        
        let urlString = SpaceXApiConstants.SpaceXURLs.APIBaseURL + SpaceXApiConstants.SpaceXMethods.launches
        print("SpaceX Url: "+urlString)
        
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.timeoutInterval = TimeInterval(SpaceXApiConstants.SpaceXNetConfig.TimeoutInterval)
        
        // create network request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                completion(nil, "Network error. Please check your network connection.")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completion(nil, "Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                completion(nil, "No data was returned by the request!")
                return
            }
            
            // parse the data
            let parsedResult: [AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [AnyObject]
            } catch {
                completion(nil, "Could not parse the data as JSON: '\(data)'")
                return
            }
            
            
            // Loop launches
            for object in parsedResult {
                let launch = Launch()
                
                if let flight_number = object["flight_number"] as? Int{
                    launch.flight_number = flight_number
                    launch.name = "Flight Number \(flight_number)"
                }
                if let launch_date_utc = object["launch_date_utc"] as? String{
                    launch.launch_date_utc = launch_date_utc
                }
                if let launch_success = object["launch_success"] as? Bool{
                    launch.launch_success = launch_success
                }
                
                if let rocket_obj = object["rocket"] as AnyObject!
                {
                    if let rocket_name = rocket_obj["rocket_name"] as? String{
                        launch.rocket = rocket_name
                    }
                }
                if let launch_site_obj = object["launch_site"] as AnyObject!{
                    if let launch_site_name = launch_site_obj["site_name_long"] as? String{
                        launch.launch_site = launch_site_name
                    }
                }

                if let links_obj = object["links"] as AnyObject!{
                    var links = ""
                    if let links_mission_patch = links_obj["mission_patch"] as? String{
                        links = "  mission link: \(links_mission_patch)\n"
                    }
                    if let links_video_link = links_obj["video_link"] as? String{
                        links = links+"  video link: \(links_video_link)\n"
                    }
                    if let links_article_link = links_obj["article_link"] as? String{
                        links = links+"  article link: \(links_article_link)\n"
                    }
                    launch.links = links
                }
                
                if let details = object["details"] as? String{
                    launch.details = details
                }
                
                launches.append(launch)
                
            }
                
               
            completion(launches, "")
        }
        
        task.resume()
        
    }
    
    public static func getLaunchPads(completion: @escaping(_ launchPads: [LaunchPad]?, _ error: String?) -> Void) {
        
        var launchPads = [LaunchPad]()
        
        let urlString = SpaceXApiConstants.SpaceXURLs.APIBaseURL + SpaceXApiConstants.SpaceXMethods.launchpads
        print("SpaceX Url: "+urlString)
        
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.timeoutInterval = TimeInterval(SpaceXApiConstants.SpaceXNetConfig.TimeoutInterval)
        
        // create network request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                completion(nil, "Network error. Please check your network connection.")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completion(nil, "Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                completion(nil, "No data was returned by the request!")
                return
            }
            
            // parse the data
            let parsedResult: [AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [AnyObject]
            } catch {
                completion(nil, "Could not parse the data as JSON: '\(data)'")
                return
            }
            
            // Loop launches
            for object in parsedResult {
                let launchPad = LaunchPad()
                
                if let id = object["id"] as? String{
                    launchPad.id = id
                }
                if let full_name = object["full_name"] as? String{
                    launchPad.full_name = full_name
                }
                if let status = object["status"] as? String{
                    launchPad.status = status
                }
                if let details = object["details"] as? String{
                launchPad.details = details
                }
                
                if let location = object["location"] as AnyObject!
                {
                    if let location_name = location["name"] as? String{
                        launchPad.location_name = location_name
                    }
                    if let location_region = location["region"] as? String{
                        launchPad.region = location_region
                    }
                    if let location_lat = location["latitude"] as? String{
                        launchPad.latitude = location_lat
                    }
                    if let location_lon = location["longitude"] as? String{
                        launchPad.longitude = location_lon
                    }
                }
                if let launch_site_obj = object["launch_site"] as! AnyObject!{
                    if let launch_site_name = launch_site_obj["site_name_long"] as? String{
                        launchPad.name = launch_site_name
                    }
                }
                
                
                launchPads.append(launchPad)
                
            }
            
            
            completion(launchPads, "")
        }
        
        task.resume()
        
    }
}
