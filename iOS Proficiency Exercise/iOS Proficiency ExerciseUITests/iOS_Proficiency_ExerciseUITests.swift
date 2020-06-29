//
//  iOS_Proficiency_ExerciseUITests.swift
//  iOS Proficiency ExerciseUITests
//
//  Created by Saipujith on 26/06/20.
//  Copyright © 2020 Saipujith. All rights reserved.
//

import XCTest

class iOS_Proficiency_ExerciseUITests: XCTestCase {
    
    private var app: XCUIApplication!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    private func testForCellExistence() {
        let detailstable = app.tables.matching(identifier: "TestTableView")
        let firstCell = detailstable.cells.element(matching: .cell, identifier: "dtTVC_0_0")
        let existencePredicate = NSPredicate(format: "exists == 1")
        let expectationEval = expectation(for: existencePredicate, evaluatedWith: firstCell, handler: nil)
        let mobWaiter = XCTWaiter.wait(for: [expectationEval], timeout: 10.0)
        XCTAssert(XCTWaiter.Result.completed == mobWaiter, "Test Case Failed.")
    }
    
    
    private func testLabelAndImageExistenceOnTable() {
         let detailstable = app.tables.matching(identifier: "TestTableView")
         let firstCell = detailstable.cells.element(matching: .cell, identifier: "dtTVC_0_0")
         XCTAssertTrue(firstCell.exists, "Table view cell not exist.")
         let keyLabel = firstCell.staticTexts["TitleLabel"] // YOUR_IDENTIFIER
         XCTAssertTrue(keyLabel.exists, "Title label not exist.")
         let valLabel = firstCell.staticTexts["DescriptionLabel"] // YOUR_IDENTIFIER
         XCTAssertTrue(valLabel.exists, "Description label not exist.")
        let callImageView = app.otherElements.containing(.image, identifier: "callActionImage").firstMatch
        XCTAssertTrue(callImageView.exists, "Image view not exist.")
        let callBGImageView = app.otherElements.containing(.image, identifier: "callBGImage").firstMatch
        XCTAssertTrue(callBGImageView.exists, "BG Image view not exist.")
    }
    
    private func checkForImageViewExistence() {
        

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // UI tests must launch the application that they test.
//        let app = XCUIApplication()
//        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
