//
//  KnowCanadaMockTests.swift
//  KnowCanadaMockTests
//
//  Created by Navdeep's Mac on 5/3/18.
//  Copyright © 2018 Navdeep. All rights reserved.
//

import XCTest
@testable import KnowCanada

class KnowCanadaMockTests: XCTestCase {
    var infoRequestRouterUnderTest : InfoRequestRouter!
    
    override func setUp() {
        super.setUp()
        infoRequestRouterUnderTest = InfoRequestRouter()
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "CanadaInfo", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
        
        //  session related information
        let url = URL (string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json")
        let urlResponse = HTTPURLResponse(url: url!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        //  Create mock session using the above mentioned values
        let sessionMock = URLSessionMock(data: data, response: urlResponse, error: nil)
        
        infoRequestRouterUnderTest.defaultSession = sessionMock as MockURLSession
        
    }
    
    override func tearDown() {
        infoRequestRouterUnderTest = nil
        super.tearDown()
    }
    
    
    // Testing to check if the call to fetch information results from the server returns success by mocking the response
    // right now we should get 14 objects and later as we refractor our code, the count will decrease
    // since we will filter out the nil values
    func testGetPropertiesResults() {
        // Given
        let promise = expectation(description: "Status code : 200")
        
        // When
        // the rows array is not initialised in the beginning
        XCTAssertNil(infoRequestRouterUnderTest.canadaInfo?.rows.count)
        // or we can assert equality
        XCTAssertEqual(infoRequestRouterUnderTest.canadaInfo?.rows.count, nil, "Empty properties array before the task begins")
        infoRequestRouterUnderTest.getSearchResults{_,_  in
            promise.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        // Then
        XCTAssertEqual(infoRequestRouterUnderTest.canadaInfo?.rows.count, 14, "Coundn't parse properly")
    }
}
