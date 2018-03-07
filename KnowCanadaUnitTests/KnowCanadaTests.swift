//
//  KnowCanadaUnitTests.swift
//  KnowCanadaUnitTests
//
//  Created by Navdeep's Mac on 3/3/18.
//  Copyright © 2018 Navdeep. All rights reserved.
//

import XCTest
@testable import KnowCanada

class KnowCanadaUnitTests: XCTestCase {
    var heightForTestString: CGFloat!
    let testString = "String to Test"
    
    var routerToTest: InfoRequestRouter!
    var data: Data!
    
    override func setUp() {
        super.setUp()
        heightForTestString = testString.height(withConstrainedWidth: 320, font: UIFont.preferredFont(forTextStyle: .headline))
        
        routerToTest = InfoRequestRouter()
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "CanadaInfo", ofType: "json")
        
        data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
        
    }
    
    func testHeightOfStringAsExpected(){
        XCTAssertEqual(heightForTestString, CGFloat(20), "Height is not as expected")
    }
    
    // Checking the data parsing function of InfoRequestRouter ..
    // Special case when title is not present, how many objects are created : Deleting title from one of the objects
    // If you delete the title from one of the objects in dummy data objects, We get only 12 objects but the file contains 14 objects
    func testUpdateSearchResultsForParsing() {
        routerToTest.updateSearchResults(String(data:data, encoding:.isoLatin1)!.data(using: .utf8)!){ result in
            switch result {
            case .success(_): XCTAssertEqual(routerToTest.canadaInfo?.rows.count, 13, "Coundn't parse properly")
            case let .failure(error) : XCTFail("failure Reason = \(error)")
            }
        }
    }
    
    // Performance testing for parsing the data
    // In order to set the metrics for this method run the tests and set performance metrics by editing the scheme
    // The test will fail or pass depending on the set scheme
    func testPerformanceOFupdateSearchResults(){
        measure{
            routerToTest.updateSearchResults(String(data:data, encoding:.isoLatin1)!.data(using: .utf8)!){ result in
                switch result {
                case .success(_): XCTAssertEqual(routerToTest.canadaInfo?.rows.count, 13, "Coundn't parse properly")
                case let .failure(error) : XCTFail("failure Reason = \(error)")
                }
            }
        }
    }
    
    override func tearDown() {
        heightForTestString = nil
        routerToTest = nil
        data = nil
        super.tearDown()
    }
    
}
