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

    func testShouldSetSelectedChampionSkinImages() {
        let mockApi = ChampionDetailAdapterMock()
        let vm = ChampionDetailViewModel(api: mockApi)
        let champion = Champion(name: "", title: "", imageName: "", skins: [], lore: "")
        
        vm.setSkinsForChampion(champion: champion)
        
        XCTAssertNotNil(vm.champion?.skins[0].splash)
    }
}
