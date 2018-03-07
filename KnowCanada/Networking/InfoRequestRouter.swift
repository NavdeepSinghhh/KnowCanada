//
//  InfoRequestRouter.swift
//  KnowCanada
//
//  Created by Navdeep's Mac on 5/3/18.
//  Copyright © 2018 Navdeep. All rights reserved.
//

import Foundation

    typealias QueryResult = (_ result : FetchResult) -> Void
    typealias FetchResult = Result<CanadaInfo, APIErrors>

class InfoRequestRouter {
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
                completion(.failure(.requestFailed(error: error as NSError)))
                return
            } else if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                self.updateSearchResults(String(data:data, encoding:.isoLatin1)!.data(using: .utf8)!){ result in
                    switch result {
                    case let .success(canadaInfo): completion(.success(canadaInfo))
                    case let .failure(error) : completion(.failure(error))
                    }
                }
            }else{
                if (response as? HTTPURLResponse) != nil{
                    completion(.failure(.responseUnsuccessful))
                }
            }
        }
        dataTask?.resume()
    }
    
    // MARK: - Helper method to parse the response and populate the model
    func updateSearchResults(_ data: Data, completion: QueryResult) {
        do {
            var canadaInfo = try decoder.decode(CanadaInfo.self, from: data)
            let filteredElements = canadaInfo.rows.filter{ $0.title != nil }
            canadaInfo.rows = filteredElements
            self.canadaInfo = canadaInfo
            completion(.success(canadaInfo))
        } catch _ as NSError {
            completion(.failure(.jsonParsingFailure))
            return
        }
    }
}
