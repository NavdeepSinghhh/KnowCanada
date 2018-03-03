//
//  KnowCanadaAsyncTests.swift
//  KnowCanadaAsyncTests
//
//  Created by Navdeep's Mac on 3/3/18.
//  Copyright © 2018 Navdeep. All rights reserved.
//

import XCTest
@testable import KnowCanada

class KnowCanadaAsyncTests: XCTestCase {
    var sessionUnderTest : URLSession!
    
    override func setUp() {
        super.setUp()
        sessionUnderTest = URLSession(configuration : URLSessionConfiguration.default)
    }
    
    override func tearDown() {
        sessionUnderTest = nil
        super.tearDown()
    }
    
    // Slow failure Async test
    // This test will time out in case something wrong goes with the request (that's why slow failure test)
    // and if the status code is something other than 200, the test will fail printing the status code 
    func testValidCallToInfoAPIGetsStatusCode200(){
        // Given
        let request = InfoRequestGenerator.fetch.asURLRequest()
        let promise = expectation(description: "Status code : 200")
        
        // when
        sessionUnderTest.dataTask(with: request) { (data, response, error) in
            // then
            if let error = error{
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                } else{
                    XCTFail("Status code = \(statusCode)")
                }
            }
            }.resume()
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // Fast Fail
    func testCallToInfoAPIServerCompletes() {
        // Given
        let request = InfoRequestGenerator.fetch.asURLRequest()
        let promise = expectation(description: "Call completes immediately by invoking completion handler")
        var statusCode : Int?
        var responseError : Error?
        
        // When
        sessionUnderTest.dataTask(with: request) { (data, response, error) in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
            }.resume()
        waitForExpectations(timeout: 5, handler: nil)
        
        // Then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
}
