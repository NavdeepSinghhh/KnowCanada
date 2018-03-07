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
    
    override func setUp() {
        super.setUp()
        heightForTestString = testString.height(withConstrainedWidth: 320, font: UIFont.preferredFont(forTextStyle: .headline))
    }
    
    func testHeightOfStringAsExpected(){
        XCTAssertEqual(heightForTestString, CGFloat(20), "Height is not as expected")
    }
    
    override func tearDown() {
        heightForTestString = nil
        super.tearDown()
    }
    
}
