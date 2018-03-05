//
//  InfoRequestRouter.swift
//  KnowCanada
//
//  Created by Navdeep's Mac on 5/3/18.
//  Copyright © 2018 Navdeep. All rights reserved.
//

import Foundation
class InfoRequestRouter {
    
    typealias QueryResult = (CanadaInfo?, String) -> ()
    var canadaInfo: CanadaInfo? 
    var errorMessage = ""
    
    // MockURLSession intead or URLSession since we want to invoke this while running our mock tests
    lazy var defaultSession: MockURLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    var dataTask: URLSessionDataTask?
    let decoder = JSONDecoder()
    
    func getSearchResults(completion: @escaping QueryResult) {
        dataTask?.cancel()
        
        let request = InfoRequestGenerator.fetch.asURLRequest()
        dataTask = defaultSession.dataTask(with: request) { data, response, error in
            defer { self.dataTask = nil }
            if let error = error {
                self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
            } else if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                print(data)
                print(String(data: data, encoding:.isoLatin1)!)
                self.updateSearchResults(String(data:data, encoding:.isoLatin1)!.data(using: .utf8)!)
                DispatchQueue.main.async {
                    completion(self.canadaInfo, self.errorMessage)
                }
            }
        }
        dataTask?.resume()
    }
    
    // MARK: - Helper method to parse the response and populate the model
    fileprivate func updateSearchResults(_ data: Data) {
        do {
            let canadaInfo = try decoder.decode(CanadaInfo.self, from: data)
            self.canadaInfo = canadaInfo
        } catch let decodeError as NSError {
            errorMessage += "Decoder error: \(decodeError.localizedDescription)"
            return
        }
    }
}
