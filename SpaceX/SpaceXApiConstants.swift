//
//  SpaceXApiConstants.swift
//  SpaceX
//
//  Created by Chris Scheid on 3/3/18.
//  Copyright © 2018 Chris Scheid. All rights reserved.
//

import Foundation

struct SpaceXApiConstants {
    
    // MARK: SpaceX
    struct SpaceXURLs {
        static let APIBaseURL = "https://api.spacexdata.com/v2/"
    }
    
    // MARK: Methods
    struct SpaceXMethods {
        static let company = "info"
        static let rockets = "rockets"
        static let capsules = "capsules"
        static let launchpads = "launchpads"
        static let launches = "launches/all"
    }
    
    // MARK: SpaceX Parameter Keys
    struct SpaceXParameterKeys {
    }
    
    // MARK: SpaceX Parameter Values
    struct SpaceXParameterValues {
    }
    
    // MARK: SpaceX Response Keys - inline
    
    // MARK: SpaceX Response Values
    struct SpaceXResponseValues {
    }
    
    // MARK: URLRequest Config
    struct SpaceXNetConfig {
        static let TimeoutInterval = 10
    }
    
    
}

