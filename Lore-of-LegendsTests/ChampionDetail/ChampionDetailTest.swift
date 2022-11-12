//
//  ChampionDetailTest.swift
//  Lore-of-LegendsTests
//
//  Created by Bertrand Dalleau on 02/11/2022.
//

import XCTest
import Combine
@testable import Lore_of_Legends

final class ChampionDetailTest: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testShouldReturnChampionLore() async {
        let mockApi = RiotCdnApiMock()
        let viewmodel = ChampionDetailViewModel(api: mockApi)
        let champion = Champion(name: "", title: "", imageName: "", skins: [], lore: "")
        let expectation = expectation(description: "Wait for async task")
        let sub = viewmodel.viewmodel.championPublisher.sink { _ in
            expectation.fulfill()
        }
        
        viewmodel.getInfo(for: champion)
        
        await waitForExpectations(timeout: 0.5)
        
        XCTAssertNotNil(viewmodel.champion?.lore)
    }
}
