//
//  RiotCdnApiMock.swift
//  Lore-of-LegendsTests
//
//  Created by Bertrand Dalleau on 27/10/2022.
//

import Foundation
@testable import Lore_of_Legends

extension RiotCdnApiMock: RiotCdnApiDelegate {
    func downloadImage(for champion: Lore_of_Legends.Champion) async throws -> Data {
        return Data()
    }
    
    func retrieveChampionFullDataJson(url: URL) async throws -> Data {
        return Data()
    }
    
    func getSupportedLanguages() async throws -> [Locale] {
        return [Locale(identifier: "")]
    }
    
    func getLastestPatchVersion() async throws -> String {
        return "12.20.1"
    }
}

extension RiotCdnApiMock: ChampionDetailAdapterDelegate {
    func setSkins(caller: Lore_of_Legends.ChampionDetailAdapter ,for champion: Lore_of_Legends.Champion) {
        let asset = ChampionAsset(fileName: "", title: "", splash: Data(), centered: Data())
        var champ = champion
        champ.skins.append(asset)
        
        caller.caller?.championDataPublisher.send(champ)
    }
}

class RiotCdnApiMock {
    
}
