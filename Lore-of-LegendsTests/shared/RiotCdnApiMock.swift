//
//  RiotCdnApiMock.swift
//  Lore-of-LegendsTests
//
//  Created by Bertrand Dalleau on 27/10/2022.
//

import Foundation
@testable import Lore_of_Legends

extension RiotCdnApiMock: ChampionListAdapterDelegate {
    func downloadImage(for champion: Lore_of_Legends.Champion) async throws -> Data {
        return Data()
    }
    
    func retrieveChampionFullDataJson(url: URL) async throws -> Data {
        return Data()
    }
    
    func getSupportedLanguages() async throws -> [String] {
        return ["fr_FR"]
    }
    
    func getLastestPatchVersion() async throws -> String {
        return "12.20.1"
    }
}

extension RiotCdnApiMock: ChampionDetailAdapterDelegate {
    func setIcon(for champion: Lore_of_Legends.Champion) async throws -> Lore_of_Legends.Champion {
        let asset = ChampionAsset(fileName: "", title: "", splash: Data())
        var champion = champion
        champion.skins.append(asset)
        
        return champion
    }
}

class RiotCdnApiMock {
    
}
