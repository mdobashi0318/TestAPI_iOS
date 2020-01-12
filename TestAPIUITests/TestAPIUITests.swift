//
//  TestAPIUITests.swift
//  TestAPIUITests
//
//  Created by 土橋正晴 on 2020/01/03.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import XCTest

class TestAPIUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
        let app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    
    func testinput() {
        let app = XCUIApplication()
        let inputName = "UITest"
        let inputText = "TestText"
        XCTContext.runActivity(named: "登録テスト") { _ in
            
            app.navigationBars.buttons.element(boundBy: 0).tap()
            app.textFields["nameTextField"].tap()
            app.typeText(inputName)
            
            app.textViews["inputTextView"].tap()
            app.typeText(inputText)
            
            app.navigationBars.buttons.element(boundBy: 1).tap()
            app.alerts.buttons.element(boundBy: 0).tap()
            sleep(1)
            XCTAssert(app.tables.cells.firstMatch.staticTexts.element(boundBy: 0).label == inputName, "登録された名前が表示されていない")
            XCTAssert(app.tables.cells.firstMatch.staticTexts.element(boundBy: 1).label == inputText, "登録されたテキストが表示されていない")
            
            
            app.tables.cells.firstMatch.tap()
            XCTAssert(app.textFields["nameTextField"].value as! String == inputName, "登録された名前が表示されていない")
            XCTAssert(app.textViews["inputTextView"].value as! String == inputText, "登録されたテキストが表示されていない")
            
            app.navigationBars.buttons.element(boundBy: 0).tap()
        }
        
        
        XCTContext.runActivity(named: "更新テスト") { _ in
            let inputNameUpdate = "UpdateName"
            let inputTextUpdate = "UpdateText"
            
            app.tables.cells.firstMatch.swipeLeft()
            app.buttons["編集"].tap()
            app.textFields["nameTextField"].tap()
            
            for _ in 0..<inputName.count {
                app.keys["delete"].tap()
            }
            app.typeText(inputNameUpdate)
            
            app.textViews["inputTextView"].press(forDuration: 2)
            app.typeText(inputTextUpdate)
            
            app.navigationBars.buttons.element(boundBy: 1).tap()
            app.alerts.buttons.element(boundBy: 0).tap()
            
            XCTAssert(app.tables.cells.firstMatch.staticTexts.element(boundBy: 0).label == inputName, "更新された名前が表示されていない")
            XCTAssert(app.tables.cells.firstMatch.staticTexts.element(boundBy: 1).label == inputText, "更新されたテキストが表示されていない")
            
            app.tables.cells.firstMatch.tap()
            XCTAssert(app.textFields["nameTextField"].value as! String == inputNameUpdate, "更新された名前が表示されていない")
            XCTAssert(app.textViews["inputTextView"].value as! String == inputTextUpdate, "更新されたテキストが表示されていない")
            
            app.navigationBars.buttons.element(boundBy: 0).tap()
        }
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
