//
//  ChampionDetailTest.swift
//  Lore-of-LegendsTests
//
//  Created by Bertrand Dalleau on 02/11/2022.
//

import XCTest
@testable import Lore_of_Legends

final class ChampionDetailTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testShouldNotifyOneChampionObject() {
        let mockApi = ChampionDetailAdapterMock()
        let vm = ChampionDetailViewModel(api: mockApi)
        let champion = Champion(name: "", title: "", imageName: "", skins: [], lore: "")
        
        vm.setSkinsForChampion(champion: champion)
        
        XCTAssertNotNil(vm.champion)
    }
    
    func testShouldReturnGivenChampionSplashImage() async throws {
        let realAdapter = ChampionDetailAdapter(delegate: RiotCdnApiMock())
        let vm = ChampionDetailViewModel(api: realAdapter)
        let champion = Champion(name: "", title: "", imageName: "", skins: [], lore: "")
        let expectation = expectation(description: "Wait for async task to finish")
        let sub = vm.model.championDataPublisher.sink(receiveValue: { _ in
            expectation.fulfill()
        })
        
        vm.setSkinsForChampion(champion: champion)
        
        await waitForExpectations(timeout: 1)
        
        sub.cancel()
    }
}
