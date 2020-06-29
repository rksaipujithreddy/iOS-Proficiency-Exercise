//
//  iOS_Proficiency_ExerciseTests.swift
//  iOS Proficiency ExerciseTests
//
//  Created by Saipujith on 26/06/20.
//  Copyright © 2020 Saipujith. All rights reserved.
//

import XCTest
@testable import iOSProficiencyExercise

class iOS_Proficiency_ExerciseTests: XCTestCase {

    var mainViewController = DashboardViewController()
    override func setUp() {
        
        super.setUp()
        mainViewController = DashboardViewController(nibName: nil, bundle: nil)
        

            mainViewController.loadView()
            mainViewController.viewDidLoad()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func testInternet() {

        
        let sampleTbl =  mainViewController.tblDashboardView
        mainViewController.setupDashboardTableView()
        sampleTbl.pullAndRefresh()
        mainViewController.getLoadedData()
        mainViewController.showAlert("", "", "")
        let cell = DashboardTableViewCell()
        cell.imgDisplay = UIImageView()
    cell.imgDisplay.loadImageUsingCacheWithURLString("http://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/American_Beaver.jpg/220px-American_Beaver.jpg", placeHolder: nil) { (bool) in
            
        }

        
        XCTAssertNotNil(mainViewController.isNetworkAvailable())

    }
    
      func checkLoadedData() {

        let sampleTbl =  mainViewController.tblDashboardView
        sampleTbl.pullAndRefresh()
        XCTAssertNotNil(mainViewController.getLoadedData())

       }
       
       func setUpDashboardView() {

       XCTAssertNotNil(mainViewController.setupDashboardTableView())

       }
    
    func loadCCellWithValid()
    {
        let cell = DashboardTableViewCell()
        cell.imgDisplay = UIImageView()
        cell.imgDisplay.loadImageUsingCacheWithURLString("http://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/American_Beaver.jpg/220px-American_Beaver.jpg", placeHolder: nil) { (bool) in
            XCTAssertTrue(bool)
        }
    }

    
    
    func testJsonDashboardModelClasswithAllValidValues() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let json = """
                 {
                 "title":"About Canada",
                 "rows":[
                     {
                     "title":"Beavers",
                     "description":"Beavers are second only to humans in their ability to manipulate and change their environment. They can measure up to 1.3 metres long. A group of beavers is called a colony",
                     "imageHref":"http://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/American_Beaver.jpg/220px-American_Beaver.jpg"
                     }
                       ]
                   }
                 """.data(using: .utf8)!
           
                 let person = try! JSONDecoder().decode(DashboardModel.self, from: json)

              let detailedModel = person.rowValue!
        _ =    mainViewController.convertJsonzToViewModelArray(dashboardItems: detailedModel)
        
                 XCTAssertEqual(person.titleValue, "About Canada")
                 XCTAssertEqual(person.rowValue?[0].titleValue, "Beavers")
                 XCTAssertEqual(person.rowValue?[0].descriptionValue, "Beavers are second only to humans in their ability to manipulate and change their environment. They can measure up to 1.3 metres long. A group of beavers is called a colony")
                 XCTAssertEqual(person.rowValue?[0].imageReferenceValue, "http://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/American_Beaver.jpg/220px-American_Beaver.jpg")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    

    
      func testDashboardJsonModelClasswithNullData() {
          let json = """
          {
          "title":"About Canada",
          "rows":[
              {
              "title":null,
              "description":null,
              "imageHref":null
              }
                ]
            }
          """.data(using: .utf8)!
    
          let person = try! JSONDecoder().decode(DashboardModel.self, from: json)
    
          XCTAssertEqual(person.titleValue, "About Canada")
          XCTAssertEqual(person.rowValue?[0].titleValue, nil)
          XCTAssertEqual(person.rowValue?[0].descriptionValue, nil)
          XCTAssertEqual(person.rowValue?[0].imageReferenceValue, nil)
    }
}
