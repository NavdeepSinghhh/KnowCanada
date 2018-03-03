//
//  InfoRequestGenerator.swift
//  KnowCanada
//
//  Created by Navdeep's Mac on 3/3/18.
//  Copyright © 2018 Navdeep. All rights reserved.
//

import Foundation
// In case the number of calls that the app makes increases, then InfoRequestGenerator can
// be modified to create all sorts of requests i.e. POST, PUT, DELETE etc.
public enum InfoRequestGenerator {
    
    // Possible requests
    case fetch 
    
    // Base endpoint
    static let baseUrlString = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
    
    // Set the method
    var method : String{
        switch self {
        case .fetch:
            return "GET"
        }
    }
    
    // Create request from url, method and parameters
    public func asURLRequest() -> URLRequest {
        let url : URL = {
            let url = URL(string: InfoRequestGenerator.baseUrlString)!
            return url
        }()
        
        // Create request
        var request = URLRequest(url: url)
        
        // Setup HTTP method
        request.httpMethod = self.method
        return request
    }
}
