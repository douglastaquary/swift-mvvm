//
//  mvvm_demoUITests.swift
//  mvvm-demoUITests
//
//  Created by NGUYEN KHANH DUY on 5/17/16.
//  Copyright © 2016 NGUYEN KHANH DUY. All rights reserved.
//

import XCTest

class mvvm_demoUITests: XCTestCase {
    
    var app = XCUIApplication()
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func waitForElementToAppear(element: XCUIElement, timeout: NSTimeInterval = 5,  file: String = #file, line: UInt = #line) {
        let existsPredicate = NSPredicate(format: "exists == true")
        
        expectationForPredicate(existsPredicate,
                                evaluatedWithObject: element, handler: nil)
        
        waitForExpectationsWithTimeout(timeout) { (error) -> Void in
            if (error != nil) {
                let message = "Failed to find \(element) after \(timeout) seconds."
                self.recordFailureWithDescription(message, inFile: file, atLine: line, expected: true)
            }
        }
    }
    
    func testSearch() {
        waitForElementToAppear(app.buttons["Reload"], timeout: 3)
        XCTAssertFalse(app.activityIndicators["In progress"].hittable)
        
        //case 1: user inputs text, automatically search after 1 sec
        let reloadElementsQuery = self.app.otherElements.containingType(.Button, identifier:"Reload")
        let textField = reloadElementsQuery.childrenMatchingType(.TextField).element
        textField.tap()
        textField.typeText("swift")
        waitForElementToAppear(self.app.tables.cells.staticTexts["apple/swift"], timeout: 10)
        sleep(1)
        
        //case 2: user click refresh
        XCUIApplication().buttons["Reload"].tap()
        XCTAssert(app.activityIndicators["In progress"].hittable)
        waitForElementToAppear(self.app.tables.cells.staticTexts["apple/swift"], timeout: 10)
        sleep(3)
        XCTAssertFalse(app.activityIndicators["In progress"].hittable)
    }
    
    
    
}
