//
//  MyChatTests.swift
//  MyChatTests
//
//  Created by Konstantin Porokhov on 02.05.2021.
//

import XCTest
@testable import MyChat

class SaveProfileServiceTests: XCTestCase {
    
    /// Service layer test
    var saveProfileService: ISaveProfileService?
    
    /// Profile
    let profile = Profile(name: "Test Testov", aboutMe: "Test text", avatarImage: nil)
    
    override func setUp() {
        super.setUp()
        let fileManager = FilesManager()
        let fileNames = FileNames()
        saveProfileService = SaveProfileService(fileManager: fileManager, fileNames: fileNames)
    }
    
    override func tearDown() {
        saveProfileService = nil
        super.tearDown()
    }
    
    func testSaveProfileServiceNotNil() {
        XCTAssertNotNil(saveProfileService)
    }
    
    func testIsSavedProfile() {
        // Given
        let profileIsSaved = saveProfile()
        
        // Then
        XCTAssertTrue(profileIsSaved)
    }
    
    func testLoadedProfileNoNil() {
        // Given
        let profile = loadProfile()
        
        // Then
        XCTAssertNotNil(profile)
    }
    
    func testEqualityBetweenSavedAndLoadedProfile() {
        // Given
        let profile = loadProfile()
        
        // Then
        XCTAssertEqual(profile?.name, self.profile.name)
        XCTAssertEqual(profile?.aboutMe, self.profile.aboutMe)
    }
    
    func testCanceledSaveOperaton() {
        // Given
        let isSaved = cancelSaveingProfile()
        
        // Then
        XCTAssertFalse(isSaved)
    }
    
    // MARK: - Logic methods
    
    private func saveProfile() -> Bool {
        var saved = false
        let expectation = XCTestExpectation(description: "saving")
        
        // When
        saveProfileService?.saveProfile(profile: profile, completion: { isSaved in
            saved = isSaved
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
        return saved
    }
    
    private func cancelSaveingProfile() -> Bool {
        var saved = true
        let expectation = XCTestExpectation(description: "canceling")
        
        // When
        saveProfileService?.saveProfile(profile: profile, completion: { isSaved in
            saved = isSaved
            expectation.fulfill()
        })
        saveProfileService?.cancel()
        
        waitForExpectations(timeout: 5, handler: nil)
        return saved
    }
    
    private func loadProfile() -> Profile? {
        
        // When
        _ = saveProfile()
        var returnProfile: Profile?
        let expectation = XCTestExpectation(description: "loading")
        saveProfileService?.loadProfile(completion: { profile in
            returnProfile = profile
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
        return returnProfile
    }

}
