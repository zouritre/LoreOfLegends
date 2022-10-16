//
//  ChampionListTest.swift
//  LoreOLTests
//
//  Created by Bertrand Dalleau on 12/10/2022.
//

@testable import Lore_of_Legends
import XCTest

final class ChampionListTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testChampionListArrayShouldContainAllChampions() throws {
        let mockApi = ChampionListApiMock(champions: [Champion(name: "", title: "", skinIds: [(0, "")], lore: "")])
        let championListVM = ChampionListViewModel(api: mockApi)
        
        championListVM.getChampions()
        
        guard let champions = championListVM.champions else {
            XCTAssertTrue(false)
            
            return
        }
        
        XCTAssertGreaterThan(champions.count, 0)
    }
    
    func testChampionListArrayShouldBeEmpty() throws {
        let mockApi = ChampionListApiMock(champions: nil)
        let championListVM = ChampionListViewModel(api: mockApi)
        
        championListVM.getChampions()
        
        guard let champions = championListVM.champions else {
            XCTAssertTrue(false)
            
            return
        }
        
        XCTAssertEqual(champions.count, 0)
    }
}
