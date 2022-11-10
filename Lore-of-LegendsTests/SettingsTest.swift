//
//  SettingsTest.swift
//  Lore-of-LegendsTests
//
//  Created by Bertrand Dalleau on 10/11/2022.
//

import XCTest
@testable import Lore_of_Legends

final class SettingsTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testShouldReturnAllSupportedLanguages() async {
        let mockApi = RiotCdnApiMock()
        let adapter = SettingsAdapter(api: mockApi)
        let viewmodel = SettingsViewModel(adapter: adapter)
        let expectation = expectation(description: "Wait for async task to finish")
        let sub = viewmodel.settings.languagesPublisher.sink(receiveCompletion: { _ in }, receiveValue: { _ in
            expectation.fulfill()
        })
        
        viewmodel.getLanguages()
        
        await waitForExpectations(timeout: 1)
        
        XCTAssertNotNil(viewmodel.languages)
        
        sub.cancel()
    }
    
    func testShouldReceiveErrorWhenAsyncTaskFails() async {
        let adapter = SettingsAdapter(api: nil)
        let viewmodel = SettingsViewModel(adapter: adapter)
        let expectation = expectation(description: "Wait for async task to finish")
        let sub = viewmodel.settings.languagesPublisher.sink(receiveCompletion: { _ in
            expectation.fulfill()
        }, receiveValue: { _ in })
        
        viewmodel.getLanguages()
        
        await waitForExpectations(timeout: 1)
        
        XCTAssertNotNil(viewmodel.requestError)
        
        sub.cancel()
    }

}
