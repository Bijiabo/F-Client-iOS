//
//  FActionTests.swift
//  F
//
//  Created by huchunbo on 15/11/16.
//  Copyright © 2015年 TIDELAB. All rights reserved.
//

import XCTest

class FActionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testGetFluxesList() {
        FAction.GET(path: "fluxes") { (request, response, json, error) -> Void in
            assert(error == nil)
            assert(json.count > 1)
            assert(json[0]["motion"].string != nil)
        }
    }
    
    func testLogin() {
        FAction.login("bijiabo@gmail.com", password: "password") { (success, description) -> Void in
            assert(success)
        }
    }
    
    func testLoggedIn() {
        FAction.login("bijiabo@gmail.com", password: "password") { (success, description) -> Void in
            assert(success)
            assert(FHelper.logged_in)
        }
    }
    
    func testCreateFlux() {
        let content = "Hello,world."
        FAction.fluxes.create(motion: "share_test", content: content, image: nil) { (success, description) -> Void in
            assert(success)
            FAction.GET(path: "fluxes", completeHandler: { (request, response, json, error) -> Void in
                let newFlux = json[0]
                assert(newFlux["content"].stringValue == content, "correct content")
                assert(newFlux["motion"].stringValue == "share_test", "correct motion.")
            })
        }
    }
    
    func testDeleteFlux() {
        //TODO: 
        //create new flux
        //delete last flux
    }
    
}
