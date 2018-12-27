//
//  Constants.swift
//  SpaceX
//
//  Created by Chris Scheid on 3/3/18.
//  Copyright © 2018 Chris Scheid. All rights reserved.
//

import Foundation

struct FlickrApiConstants {
    
    // MARK: Flickr
    struct Flickr {
        static let APIBaseURL = "https://api.flickr.com/services/rest/"
    }
    
    // MARK: Flickr Parameter Keys
    struct FlickrParameterKeys {
        static let Method = "method"
        static let APIKey = "api_key"
        static let Extras = "extras"
        static let Format = "format"
        static let Tags = "tags"
        static let Page = "page"
        static let PerPage = "per_page"
        static let NoJSONCallback = "nojsoncallback"
        static let SafeSearch = "safe_search"
    }
    
    // MARK: Flickr Parameter Values
    struct FlickrParameterValues {
        static let APIKey = "6018ce76bba90c3eff10d2f95093f634"
        static let Tag = "SpaceX,SpaceX falcon,SpaceX Rocket,SpaceX Dragon,Elon Musk"
        static let ResponseFormat = "json"
        static let DisableJSONCallback = "1" /* 1 means "yes" */
        static let SearchPhotosMethod = "flickr.photos.search"
        static let MediumURL = "url_m"
        static let SaveSearchValue = "1"
        static let PerPageValue = "30"
    }
    
    // MARK: Flickr Response Keys
    struct FlickrResponseKeys {
        static let Status = "stat"
        static let Photos = "photos"
        static let Photo = "photo"
        static let Title = "title"
        static let MediumURL = "url_m"
    }
    
    // MARK: Flickr Response Values
    struct FlickrResponseValues {
        static let OKStatus = "ok"
    }

}

