//
//  RiotCdnApiMock.swift
//  Lore-of-LegendsTests
//
//  Created by Bertrand Dalleau on 27/10/2022.
//

import Foundation
import Combine
@testable import Lore_of_Legends

extension RiotCdnApiMock: RiotCdnApiDelegate {
    func getLastestPatchVersion() async throws -> String {
        return "1.2.4"
    }
    
    func setInfo(for champion: Lore_of_Legends.Champion) async throws -> Lore_of_Legends.Champion {
        return Champion(id: "", name: "", title: "", skins: [], lore: "")
    }
    
    func setSkins(for champion: Lore_of_Legends.Champion) async throws -> Lore_of_Legends.Champion {
        return Champion(id: "", name: "", skins: [])
    }
    
    func setTitle(for champion: Lore_of_Legends.Champion) async throws -> Lore_of_Legends.Champion {
        var champion = champion
        
        champion.setTitle(with: "Hello")
        
        return champion
    }
    
    func setLore(for champion: Lore_of_Legends.Champion) -> Champion {
        var champion = champion
        
        champion.setLore(with: "Hello")
        
        return champion
    }
    
    func getChampions(caller: HomeScreen) async throws -> [Lore_of_Legends.Champion] {
        if throwing {
            throw MockError()
        }
        else {
            caller.totalNumberOfChampionsPublisher.send(1)
            caller.iconsDownloadedPublisher.value = 1
            
            return [Champion(id: "", name: "Aatrox", title: "", icon: Data(), skins: [], lore: "")]
        }
    }
    
    func getSupportedLanguages() async throws -> [Locale] {
        return [Locale(identifier: "")]
    }
}

//extension RiotCdnApiMock: ChampionDetailAdapterDelegate {
//    func setSkins(caller: Lore_of_Legends.ChampionDetailAdapter ,for champion: Lore_of_Legends.Champion) {
//        let asset = ChampionAsset(fileName: "", title: "", splash: Data(), centered: Data())
//        var champ = champion
//        champ.skins.append(asset)
//        
//        caller.caller?.championDataPublisher.send(champ)
//    }
//}

class RiotCdnApiMock {
    var throwing: Bool = false
    
    init(throwing: Bool? = nil) {
        if throwing != nil {
            self.throwing = true
        }
    }
}

class MockError: Error {}
