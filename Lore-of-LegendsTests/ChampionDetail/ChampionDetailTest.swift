//
//  ChampionDetailTest.swift
//  Lore-of-LegendsTests
//
//  Created by Bertrand Dalleau on 02/11/2022.
//

import XCTest
@testable import Lore_of_Legends

final class ChampionDetailTest: XCTestCase {
    
    var mockApi: RiotCdnApiMock!
    var viewmodel: ChampionDetailViewModel!
    var champion: Champion!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockApi = RiotCdnApiMock()
        viewmodel = ChampionDetailViewModel(api: mockApi)
        champion = Champion(id: "", name: "", title: "", skins: [], lore: "")
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testShouldReturnChampionLore() async {
        await viewmodel.setLore(for: champion)
        
        XCTAssertNotNil(viewmodel.champion?.lore)
    }
    
    func testShouldReturnChampionHonorificTitle() async {
        await viewmodel.setTitle(for: champion)
        
        XCTAssertNotNil(viewmodel.champion?.title)
    }
    
    func testShouldReturnChampionSkins() async {
        await viewmodel.setSkins(for: champion)
        
        XCTAssertNotNil(viewmodel.champion?.skins)
    }
    
    func testShouldReturnChampionHonorificTitleAndLoreAndSkins() async {
        await viewmodel.setInfo(for: champion)
        
        XCTAssertNotNil(viewmodel.champion?.skins)
        XCTAssertNotNil(viewmodel.champion?.lore)
        XCTAssertNotNil(viewmodel.champion?.title)
    }
}
