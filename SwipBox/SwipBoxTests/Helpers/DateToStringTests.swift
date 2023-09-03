//
//  DateToStringTests.swift
//  SwipBoxTests
//
//  Created by Zain Sidhu on 03/09/2023.
//


import XCTest
@testable import SwipBox

class DateToStringTests: XCTestCase {
    
    func testToString_yyyyMMdd() {
        let date = Date(timeIntervalSince1970: 1693724228) // Date for "2023-09-03" in UTC
        let dateString = date.toString(dateFormat: .yyyyMMdd)
        XCTAssertEqual(dateString, "2023-09-03")
    }
    
    func testToString_ddMMMyyyy() {
        let date = Date(timeIntervalSince1970: 1693724228) // Date for "2023-09-03" in UTC
        let dateString = date.toString(dateFormat: .ddMMMyyyy)
        XCTAssertEqual(dateString, "03 Sep 2023")
    }
}
