//
//  ChampionListAdapterTest.swift
//  Lore-of-LegendsTests
//
//  Created by Bertrand Dalleau on 27/10/2022.
//

import XCTest
import Combine
@testable import Lore_of_Legends

final class ChampionListAdapterTest: XCTestCase {
    var adapter =  ChampionListAdapter()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        adapter = ChampionListAdapter()
        let mockApi = RiotCdnApiMock()
        
        adapter.delegate = mockApi
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testShouldReturnLastestPatchVersion() async throws {
        _ = try await adapter.delegate.getLastestPatchVersion()
    }
    
//    func testApiShouldReturnAllLocalizationSupported() async throws {
//         let languages = try await adapter?.delegate?.getSupportedLanguages()
//
//        XCTAssertNotNil(languages)
//    }

    func testShouldReturnUserSelectedLanguage() {
        UserDefaults.standard.set("fr_FR", forKey: "Lore Language")
        let locale = adapter.getLanguageForChampionsData()
        
        XCTAssertEqual(locale.identifier, "fr_FR")
    }
    
    func testShouldReturnDefaultLanguage() {
        UserDefaults.standard.removeObject(forKey: "Lore Language")
        
        let locale = adapter.getLanguageForChampionsData()
        
        let deviceLanguage = Locale.current.language.languageCode?.identifier
        
        switch deviceLanguage {
        case "fr":
            XCTAssertEqual(locale.identifier, "fr_FR")
        default:
            XCTAssertEqual(locale.identifier, "en_US")
        }
    }
    
    func testShouldReturnUrlForChampionsData() throws {
        XCTAssertNoThrow(try adapter.getChampionsDataUrl(patchVersion: "12.20.1", localization: "fr_FR"))
    }
    
    func testShouldReturnChampionsDataAsDataObject() async throws {
        _ = try await adapter.delegate.retrieveChampionFullDataJson(url: URL(string: "https://www.google.com/")!)
    }
    
    func testShouldDecodeGivenData() throws {
        let bundle = Bundle(for: Self.self)
        let jsonUrl = bundle.url(forResource: "championFull", withExtension: "json")
        
        guard let jsonUrl else { throw NSError(domain: "", code: 0)}
        
        let data = try Data(contentsOf: jsonUrl)
        
        XCTAssertNoThrow(try adapter.decodeChampionDataJson(from: data))
    }
    
    func testShouldFailDecodingGivenData() throws {
        XCTAssertThrowsError(try adapter.decodeChampionDataJson(from: Data()))
    }
    
    func testShouldReturnChampionsArrayFromDecodable() throws {
        let bundle = Bundle(for: Self.self)
        let jsonUrl = bundle.url(forResource: "championFull", withExtension: "json")
        
        guard let jsonUrl else { throw NSError(domain: "", code: 0)}
        
        let data = try Data(contentsOf: jsonUrl)
        let decodable = try adapter.decodeChampionDataJson(from: data)
        let champions = adapter.createChampionsObjects(from: decodable)
        
        XCTAssertGreaterThan(champions.count, 0)
    }
    
    func testShouldSetIconsForEveryChampions() async {
        let expectation = expectation(description: "Wait for champion to be returned")
        let model = ChampionList()
        let sub = model.championDataSubject.sink(receiveCompletion: { _ in }, receiveValue: { champion in
            expectation.fulfill()
        })
        
        adapter.setIcons(caller: model, for: [Champion(name: "", title: "", imageName: "", skins: [], lore: "")])
        
        await waitForExpectations(timeout: 1)
    }
    
    func testShouldDownloadIconForGivenChampion() async throws {
        _ = try await adapter.delegate.downloadImage(for: Champion(name: "", title: "", imageName: "", skins: [], lore: ""))
    }
}
