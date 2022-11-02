//
//  ChampionDetailAdapterTest.swift
//  Lore-of-LegendsTests
//
//  Created by Bertrand Dalleau on 02/11/2022.
//

import XCTest
@testable import Lore_of_Legends

final class ChampionDetailAdapterTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testShouldReturnGivenChampionSplashImage() async throws {
        let adapter = ChampionDetailAdapter(delegate: RiotCdnApiMock())
        let champion = Champion(name: "", title: "", imageName: "", skins: [], lore: "")
        
        let championWithSkins = try await adapter.delegate?.setIcon(for: champion)
        
        XCTAssertNotNil(championWithSkins?.skins[0].splash)
    }

}
