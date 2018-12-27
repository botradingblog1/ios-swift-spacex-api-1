//
//  FlickrApiClient.swift
//  SpaceX
//
//  Created by Chris Scheid on 3/3/18.
//  Copyright © 2018 Chris Scheid. All rights reserved.
//

import Foundation
import UIKit

class FlickrApiClient: NSObject {
    
    public static func getPhotoImages(completion: @escaping(_ imageUrls: [String]?, _ error: String?) -> Void) {
        
        var imageUrlArray = [String]()

        let randomPage = (arc4random_uniform(10) + 1)
        
        let methodParameters = [
            FlickrApiConstants.FlickrParameterKeys.Method: FlickrApiConstants.FlickrParameterValues.SearchPhotosMethod,
            FlickrApiConstants.FlickrParameterKeys.APIKey: FlickrApiConstants.FlickrParameterValues.APIKey,
            FlickrApiConstants.FlickrParameterKeys.Tags: FlickrApiConstants.FlickrParameterValues.Tag,
            FlickrApiConstants.FlickrParameterKeys.Extras: FlickrApiConstants.FlickrParameterValues.MediumURL,
            FlickrApiConstants.FlickrParameterKeys.Format: FlickrApiConstants.FlickrParameterValues.ResponseFormat,
            FlickrApiConstants.FlickrParameterKeys.Page: String(randomPage),
            FlickrApiConstants.FlickrParameterKeys.PerPage: FlickrApiConstants.FlickrParameterValues.PerPageValue,
            FlickrApiConstants.FlickrParameterKeys.NoJSONCallback: FlickrApiConstants.FlickrParameterValues.DisableJSONCallback
        ]
        
        let urlString = FlickrApiConstants.Flickr.APIBaseURL + escapedParameters(methodParameters as [String:AnyObject])
        //print("Flickr Url: "+urlString)
        
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
                completion(nil, "Could not parse the data as JSON: '\(data)'")
                return
            }
            
            /* GUARD: Did Flickr return an error (stat != ok)? */
            guard let stat = parsedResult[FlickrApiConstants.FlickrResponseKeys.Status] as? String, stat == FlickrApiConstants.FlickrResponseValues.OKStatus else {
                completion(nil, "Flickr API returned an error. See error code and message in \(parsedResult)")
                return
            }
            
            /* GUARD: Are the "photos" and "photo" keys in our result? */
            guard let photosDictionary = parsedResult[FlickrApiConstants.FlickrResponseKeys.Photos] as? [String:AnyObject], let photoArray = photosDictionary[FlickrApiConstants.FlickrResponseKeys.Photo] as? [[String:AnyObject]] else {
                completion(nil, "Cannot find keys '\(FlickrApiConstants.FlickrResponseKeys.Photos)' and '\(FlickrApiConstants.FlickrResponseKeys.Photo)' in \(parsedResult)")
                return
            }
            
            // Loop results and get image url
            for photo in photoArray {
                if let imageUrl = photo["url_m"] as? String {
                    imageUrlArray.append(imageUrl)
                }
            }
            completion(imageUrlArray, "")
        }
        
        task.resume()
        
    }
    
    public static func getImage(with url: String, completion: @escaping(_ data: Data?, _ error: String?) -> Void) {
        
        downloadTask(with: url, convertData: false) { (response, error) in
            completion(response as? Data, error)
        }
    }
    
    private static func downloadTask(with url: String, convertData: Bool, completion: @escaping(_ response: AnyObject?, _ error: String?) -> Void) {
        
        let request = NSMutableURLRequest(url: URL(string: url)!)
        request.timeoutInterval = TimeInterval(SpaceXApiConstants.SpaceXNetConfig.TimeoutInterval)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard (error == nil) else {
                completion(nil, "Network error. Some images could not be downloaded.")
                return
            }
            
            guard let data = data else {
                completion(nil, "No data was returned by the request!")
                return
            }
            
            guard let code = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(code) else {
                completion(nil, "Not a successfull status code")
                return
            }
            
            if convertData {
                self.convertData(data, completion: completion)
            } else {
                completion(data as AnyObject?, nil)
            }
        }
        
        task.resume()
    }
    
    private static func convertData(_ data: Data, completion: (_ response: AnyObject?, _ error: String?) -> Void) {
        var parsedResult: AnyObject! = nil
        
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            completion(nil, "Error parsing json")
        }
        
        completion(parsedResult, nil)
    }
    
    
    private static func escapedParameters(_ parameters: [String:AnyObject]) -> String {
        
        if parameters.isEmpty {
            return ""
        } else {
            var keyValuePairs = [String]()
            
            for (key, value) in parameters {
                
                // make sure that it is a string value
                let stringValue = "\(value)"
                
                // escape it
                let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                
                // append it
                keyValuePairs.append(key + "=" + "\(escapedValue!)")
                
            }
            
            return "?\(keyValuePairs.joined(separator: "&"))"
        }
    }
}
