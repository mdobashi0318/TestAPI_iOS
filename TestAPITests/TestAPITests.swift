//
//  TestAPITests.swift
//  TestAPITests
//
//  Created by 土橋正晴 on 2020/01/03.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import XCTest
@testable import TestAPI



protocol TestRegisterVCProtocol {
    
    /// RegisterViewControllerのinit時にmodeが反映されるかテスト
    func test_RegisterVCInitMode()
}




class TestAPITests: XCTestCase, TestRegisterVCProtocol {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    /// RegisterViewController
    func test_RegisterVCInitMode() {
        var vc = RegisterTableViewController(mode: .add, userModel: nil)
        XCTAssertEqual(vc.mode, .add, "Modeが違う")
        
        vc = RegisterTableViewController(mode: .detail, userModel: nil)
        XCTAssertEqual(vc.mode, .detail, "Modeが違う")
        
        vc = RegisterTableViewController(mode: .edit, userModel: nil)
        XCTAssertEqual(vc.mode, .edit, "Modeが違う")
        
    }

}
