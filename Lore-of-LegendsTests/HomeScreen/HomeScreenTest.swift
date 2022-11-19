//
//  HomeScreenTest.swift
//  Lore-of-LegendsTests
//
//  Created by Bertrand Dalleau on 10/11/2022.
//

import XCTest
@testable import Lore_of_Legends

final class HomeScreenTest: XCTestCase {
    var mockApi: RiotCdnApiMock!
    var viewmodel: HomeScreenViewModel!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockApi = RiotCdnApiMock()
        viewmodel = HomeScreenViewModel(riotCdnapi: mockApi)
        viewmodel.homescreen.isAssetSavedLocally = false
        viewmodel.homescreen.patchVersionForAssetsSaved = nil
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testShouldReturnChampionNameAndIcon() async {
        await viewmodel.getChampions()
        
        guard let champions = viewmodel.champions else {
            XCTAssertTrue(false)
            
            return
        }
        
        XCTAssertNotNil(champions[0].icon)
        XCTAssertGreaterThan(champions[0].name.count, 0)
    }
    
    func testShouldThrowAnError() async {
        let mockApi = RiotCdnApiMock(throwing: true)
        let viewmodel = HomeScreenViewModel(riotCdnapi: mockApi)
        
        await viewmodel.getChampions()
        
        XCTAssertNotNil(viewmodel.error)
    }
    
    func testShouldReturnChampionsIconDownloadProgress() async {
        await viewmodel.getChampions()
        
        XCTAssertNotNil(viewmodel.iconsDownloaded)
    }
    
    func testShouldReturnTotalNumberOfChampionsInLeague() async {
        await viewmodel.getChampions()
        
        XCTAssertEqual(viewmodel.totalNumberOfChampions, 1)
    }
    
    func testShouldReturnLastestPatchVersion() async {
        viewmodel.homescreen.isAssetSavedLocally = true
        viewmodel.homescreen.patchVersionForAssetsSaved = "1.2.3"

        await viewmodel.getChampions()
        
        XCTAssertNotNil(viewmodel.newUpdate)
    }
}
