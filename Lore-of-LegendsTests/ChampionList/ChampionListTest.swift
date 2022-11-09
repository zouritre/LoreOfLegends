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
        let mockApi = ChampionListAdapterMock(champions: [Champion(name: "", title: "", imageName: "", skins: [ChampionAsset(fileName: "", title: "")], lore: "")])
        let championListVM = ChampionListViewModel(api: mockApi)
        
        championListVM.getChampions()
        
        XCTAssertGreaterThan(championListVM.champions.count, 0)
        XCTAssertNil(championListVM.championsDataError)
    }
    
    func testChampionListArrayShouldBeEmpty() throws {
        let mockApi = ChampionListAdapterMock(champions: nil)
        let championListVM = ChampionListViewModel(api: mockApi)
        
        championListVM.getChampions()
        
        
        XCTAssertEqual(championListVM.champions.count, 0)
        XCTAssertNotNil(championListVM.championsDataError)
    }
    
    func testChampionIconImageShouldBeReturned() {
        let api = ChampionListAdapterMock(champions: [Champion(name: "", title: "", imageName: "", icon: Data(), skins: .init(), lore: "")])
        let viewModel = ChampionListViewModel(api: api)
        
        viewModel.getChampions()
        
        XCTAssertNotNil(viewModel.champions[0].icon)
    }
    
    func testShouldReturnAvailableChampionsCount() {
        let api = ChampionListAdapterMock(champions: [Champion(name: "", title: "", imageName: "", icon: Data(), skins: .init(), lore: "")])
        let viewModel = ChampionListViewModel(api: api)
        
        viewModel.getChampions()
        
        XCTAssertEqual(viewModel.totalChampionsCount, 1)
    }
    
    func testShouldReturnChampionsDownloadProgress() {
        let api = ChampionListAdapterMock(champions: [Champion(name: "", title: "", imageName: "", icon: Data(), skins: .init(), lore: "")])
        let viewModel = ChampionListViewModel(api: api)
        
        viewModel.getChampions()
        
        XCTAssertEqual(viewModel.downloadedChampionsCount, 1)
    }
    
    func testShouldReturnTrueIfDownloadIsRunning() {
        let api = ChampionListAdapterMock(champions: [Champion(name: "", title: "", imageName: "", icon: Data(), skins: .init(), lore: "")])
        let viewModel = ChampionListViewModel(api: api)
        
        UserDefaults.standard.set(false, forKey: UserDefaultKeys.isAssetSavedLocally.rawValue)

        viewModel.getChampions()
        
        XCTAssertTrue(viewModel.isDownloading)
    }
}
