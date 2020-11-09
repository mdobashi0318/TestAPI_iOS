//
//  RegisterViewControllerPresenterTest.swift
//  TestAPITests
//
//  Created by 土橋正晴 on 2020/08/16.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import XCTest
@testable import TestAPI

class RegisterViewControllerPresenterTest: XCTestCase {
    
    var presenter: RegisterViewControllerPresenter?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        presenter = RegisterViewControllerPresenter()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_postRequest() throws {
        let exp = expectation(description: "post")
        
        presenter?.postRequest(name: "UnitTest", text: "UnitTestText", image: nil, success: { 
            exp.fulfill()
        }, failure: { _, _ in
            
        })
         
        wait(for: [exp], timeout: 3.0)
    }
    
    
    
    func test_puttRequest() throws {
        let exp = expectation(description: "put")
        
        presenter?.putRequest(id: 1, name: "UnitPutTest", text: "UnitPutTestText", image: nil, success: {
            ///
            exp.fulfill()
        }, failure: { _, _ in
            
        })
        
        wait(for: [exp], timeout: 3.0)
    }
    
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
