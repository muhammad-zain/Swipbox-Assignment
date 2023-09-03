//
//  StringToDateTests.swift
//  SwipBoxTests
//
//  Created by Zain Sidhu on 03/09/2023.
//

import XCTest
@testable import SwipBox

class StringToDateTests: XCTestCase {
    
    func testValidDateFormat_yyyyMMdd() {
        
        let dateString = "2023-09-03"
        let date = dateString.toDate(dateFormat: .yyyyMMdd)
        XCTAssertNotNil(date)
    }
    
    func testValidDateFormat_ddMMMyyyy() {
        let dateString = "03 Sep 2023"
        let date = dateString.toDate(dateFormat: .ddMMMyyyy)
        XCTAssertNotNil(date)
    }
    
    func testInvalidDateFormat() {
        let dateString = "2023/09/03"
        let date = dateString.toDate(dateFormat: .yyyyMMdd)
        XCTAssertNil(date)
    }
    
    func testEmptyString() {
        let dateString = ""
        let date = dateString.toDate(dateFormat: .yyyyMMdd)
        XCTAssertNil(date)
    }
}
