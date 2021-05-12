//
//  MyChatUITests.swift
//  MyChatUITests
//
//  Created by Konstantin Porokhov on 02.05.2021.
//

import XCTest
@testable import MyChat

class ProfileVCUITests: XCTestCase {
    
    var app: XCUIApplication?
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app?.launch()
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    func testForThePresenceOfTwoTextFieldsGrayBox() {
        
        // Given
        let navigationBurTitle = "Tinkoff Chat"
        let buttonValue = "Profile"
        let textID = "value"
        
        // When
        app?.navigationBars[navigationBurTitle].buttons[buttonValue].tap()
        let textfields = app?.textFields.containing(.textField, identifier: textID)
        let textViews = app?.textViews.containing(.textView, identifier: textID)
        let textCount = (textfields?.count ?? 0) + (textViews?.count ?? 0)
       
        // Then
        XCTAssertEqual(textCount, 2)
    }
    
    func testForThePresenceOfTwoTextFieldsBlackBox() {
        
        // Given
        let navigationBurTitle = "Tinkoff Chat"
        let buttonValue = "Profile"
        
        // When
        app?.navigationBars[navigationBurTitle].buttons[buttonValue].tap()
        guard let textfieldsCount = app?.textFields.count,
              let textViewsCount = app?.textViews.count else {
            XCTFail("Error: required text fields not found")
            return
        }
        let textCount = textViewsCount + textfieldsCount
       
        // Then
        if #available(iOS 14.0, *) {
            XCTAssertEqual(textCount, 3)
        } else {
            XCTAssertEqual(textCount, 2)
        }
        // 1. TextField   'ФИО'
        // 2. TextView   'AboutMe'  state label  ( textView.isEnabled = false ) iOS 14.0
        // 3. TextView   'AboutMe'  state value  ( textView.isEnabled = true )
    }
}

// Какой метод оставить?
