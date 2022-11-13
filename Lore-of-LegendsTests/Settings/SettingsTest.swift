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

    func testShouldReturnAllLanguagesSupportedByRiotCdn() async {
        let mockApi = RiotCdnApiMock()
        let viewmodel = SettingsViewModel(riotCdnApi: mockApi)
        let expectation = expectation(description: "Wait for asyn task")
        let sub = viewmodel.settings.languagesPublisher.sink { _ in
            expectation.fulfill()
        }
        
        viewmodel.getSupportedLanguages()
        
        await waitForExpectations(timeout: 0.5)
        
        XCTAssertNotNil(viewmodel.languages)
        
        sub.cancel()
    }

}
