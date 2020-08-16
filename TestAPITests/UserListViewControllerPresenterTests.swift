//
//  UserListViewControllerPresenterTests.swift
//  TestAPITests
//
//  Created by 土橋正晴 on 2020/08/16.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import XCTest
@testable import TestAPI

class UserListViewControllerPresenterTests: XCTestCase {
    
    var presenter: UserListViewControllerPresenter?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        presenter = UserListViewControllerPresenter()
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func test_fetchUsers() {
        
        let exp = expectation(description: "fetch")
        presenter?.fetchUsers(success: {
            XCTAssertNotNil(self.presenter?.model, "モデルに格納されていない")
            exp.fulfill()
        }, failure: { _ in
            
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
