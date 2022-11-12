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
    
    var mockApi: RiotCdnApiMock!
    var viewmodel: ChampionDetailViewModel!
    var champion: Champion!
    var expectation: XCTestExpectation!
    var sub: AnyCancellable!
        
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockApi = RiotCdnApiMock()
        viewmodel = ChampionDetailViewModel(api: mockApi)
        champion = Champion(name: "", title: "", imageName: "", skins: [], lore: "")
        expectation = expectation(description: "Wait for async task")
        sub = viewmodel.viewmodel.championPublisher.sink { [unowned self] _ in
            expectation.fulfill()
        }
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testShouldReturnChampionLore() async {
        viewmodel.setLore(for: champion)
        
        await waitForExpectations(timeout: 0.5)
        
        XCTAssertNotNil(viewmodel.champion?.lore)
        
        sub.cancel()
    }
    
    func testShouldReturnChampionHonorificTitle() async {
        viewmodel.setTitle(for: champion)
        
        await waitForExpectations(timeout: 0.5)
        
        XCTAssertNotNil(viewmodel.champion?.title)
        
        sub.cancel()
    }
}
