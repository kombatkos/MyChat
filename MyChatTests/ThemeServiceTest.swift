//
//  ThemeServiceTest.swift
//  MyChatTests
//
//  Created by Konstantin Porokhov on 03.05.2021.
//

import XCTest
@testable import MyChat

class ThemeServiceTest: XCTestCase {

    /// Service layer test
    var themeService: IThemeService?
    
    override func setUp() {
        super.setUp()
        let fileManager = FilesManager()
        let fileNames = FileNames()
        themeService = ThemeService(fileNames: fileNames, filesManager: fileManager)
    }
    
    override func tearDown() {
        themeService = nil
        super.tearDown()
    }
    
    func testCurrentThemeNotNil() {
        // Given
        let currentTheme = themeService?.currentTheme()
        
        // Then
        XCTAssertNotNil(currentTheme)
    }
    
    func testCurrentThemeLoading() {
        // Given
        let theme: Theme = .classic
        
        // When
        _ = applyTheme(theme: theme)
        let currentTheme = themeService?.currentTheme()
        
        // When
        XCTAssertEqual(currentTheme, theme)
    }
    
    func testIsApplyTheme() {
        // Given
        let theme: Theme = .night
        
        // When
        let isApply = applyTheme(theme: theme)
        
        // Then
        XCTAssertTrue(isApply)
    }
    
    private func applyTheme(theme: Theme) -> Bool {
        var isApply = false
        
        // When
        let expectation = expectation(description: "apply")
        themeService?.applyTheme(theme: theme, completion: { apply in
            isApply = apply
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
        
        return isApply
    }

}
