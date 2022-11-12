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
    var expectation: XCTestExpectation!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockApi = RiotCdnApiMock()
        viewmodel = HomeScreenViewModel(riotCdnapi: mockApi)
        expectation = expectation(description: "Wait for async task")
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testShouldReturnChampionNameAndIcon() async {
        let sub = viewmodel.homescreen.championsPublisher.sink(receiveCompletion: { _ in }, receiveValue: { [unowned self] _ in
            expectation.fulfill()
        })
        
        viewmodel.getChampions()
        
        await waitForExpectations(timeout: 0.5)
        
        guard let champions = viewmodel.champions else {
            XCTAssertTrue(false)
            
            return
        }
        
        XCTAssertNotNil(champions[0].icon)
        XCTAssertGreaterThan(champions[0].name.count, 0)
        
        sub.cancel()
    }
    
    func testShouldThrowAnError() async {
        let mockApi = RiotCdnApiMock(throwing: true)
        let viewmodel = HomeScreenViewModel(riotCdnapi: mockApi)
        let sub = viewmodel.homescreen.championsPublisher.sink(receiveCompletion: { [unowned self] _ in
            expectation.fulfill()
        }, receiveValue: { _ in })
        
        viewmodel.getChampions()
        
        await waitForExpectations(timeout: 0.5)
        
        XCTAssertNotNil(viewmodel.error)
        
        sub.cancel()
    }
    
    func testShouldReturnChampionsIconDownloadProgress() async {
        let sub = viewmodel.homescreen.$iconsDownloadedPublisher.sink { [unowned self] _ in
            expectation.fulfill()
        }
        
        viewmodel.getChampions()
        
        await waitForExpectations(timeout: 0.5)
        
        XCTAssertNotNil(viewmodel.iconsDownloaded)
        
        sub.cancel()
    }
    
    func testShouldReturnTotalNumberOfChampionsInLeague() async {
        let sub = viewmodel.homescreen.totalNumberOfChampionsPublisher.sink { [unowned self] _ in
            expectation.fulfill()
        }
        
        viewmodel.getChampions()
        
        await waitForExpectations(timeout: 1)
        
        XCTAssertEqual(viewmodel.totalNumberOfChampions, 1)
        
        sub.cancel()
    }
}
