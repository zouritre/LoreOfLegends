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

    var mockApi: RiotCdnApiMock?
    var adapter: ChampionDetailAdapter?
    var model: ChampionDetail?
    var vm: ChampionDetailViewModel?
    var champion = Champion(name: "", title: "", imageName: "", skins: [], lore: "")
    var expectation: XCTestExpectation?
    var sub: AnyCancellable?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockApi = RiotCdnApiMock()
        
        guard let mockApi else { return }
        
        adapter = ChampionDetailAdapter(delegate: mockApi)
        
        guard let adapter else { return }
        
        model = ChampionDetail(adapter: adapter)
        
        guard let model else { return }
        
        vm = ChampionDetailViewModel(model: model)
        
        guard let vm else { return }
        
        expectation = expectation(description: "Wait for champion data")
        
        guard let expectation else { return }
        
        sub = vm.$champion.sink(receiveValue: { champ in
            if champ != nil {
                expectation.fulfill()
            }
        })
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testShouldNotifyOneChampionObject() async {
        vm?.setSkinsForChampion(champion: champion)
        
        await waitForExpectations(timeout: 1)
        
        XCTAssertNotNil(vm?.champion)
    }
    
    func testShouldReturnGivenChampionSplashImage() async {
        
        vm?.setSkinsForChampion(champion: champion)
        
        await waitForExpectations(timeout: 1)
        
        XCTAssertNotNil(vm?.champion?.skins[0].splash)
    }
    
    func testShouldReturnGivenChampionCenteredImage() async {
        
        vm?.setSkinsForChampion(champion: champion)
        
        await waitForExpectations(timeout: 1)
        
        XCTAssertNotNil(vm?.champion?.skins[0].centered)
    }
}
