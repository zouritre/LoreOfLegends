//
//  HomeScreenTest.swift
//  Lore-of-LegendsTests
//
//  Created by Bertrand Dalleau on 10/11/2022.
//

import XCTest
@testable import Lore_of_Legends

final class HomeScreenTest: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testShouldReturnEveryChampionsIcon() async {
        let mockApi = RiotCdnApiMock()
        let viewmodel = HomeScreenViewModel(riotCdnapi: mockApi)
        let expectation = expectation(description: "Wait for async task")
        let sub = viewmodel.homescreen.championsPublisher.sink { _ in
            expectation.fulfill()
        }
        
        viewmodel.getChampionsIcon()
        
        await waitForExpectations(timeout: 0.5)
        
        XCTAssertNotNil(viewmodel.champions?[0].icon)
        
        sub.cancel()
    }
    
    func testShouldReturnChampionsName() async {
        let mockApi = RiotCdnApiMock()
        let viewmodel = HomeScreenViewModel(riotCdnapi: mockApi)
        let expectation = expectation(description: "Wait for async task")
        let sub = viewmodel.homescreen.championsPublisher.sink { _ in
            expectation.fulfill()
        }
        
        viewmodel.getChampionsName()
        
        await waitForExpectations(timeout: 0.5)
        
        guard let name = viewmodel.champions?[0].name else {
            XCTAssertTrue(false)
            
            return
        }
        
        XCTAssertGreaterThan(name.count, 0)
        
        sub.cancel()
    }
    
    func testShouldReturnChampionNameAndIcon() async {
        let mockApi = RiotCdnApiMock()
        let viewmodel = HomeScreenViewModel(riotCdnapi: mockApi)
        let expectation = expectation(description: "Wait for async task")
        let sub = viewmodel.homescreen.championsPublisher.sink { _ in
            expectation.fulfill()
        }
        
        viewmodel.getChampions()
        
        await waitForExpectations(timeout: 0.5)
        
        XCTAssertNotNil(viewmodel.champions?[0].icon)
        XCTAssertGreaterThan(name.count, 0)
        
        sub.cancel()
    }
    
}
