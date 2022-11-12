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
    func getChampions(caller: HomeScreen) async throws -> [Lore_of_Legends.Champion] {
        if throwing {
            throw MockError()
        }
        else {
            caller.totalNumberOfChampionsPublisher.send(1)
            caller.iconsDownloadedPublisher = 1
            
            return [Champion(name: "Aatrox", title: "", imageName: "", icon: Data(), skins: [], lore: "")]
        }
    }
    
    func getSupportedLanguages() async throws -> [Locale] {
        if throwing {
            throw MockError()
        }
        
        return [Locale(identifier: "")]
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
    var throwing: Bool = false
    
    init(throwing: Bool? = nil) {
        if throwing != nil {
            self.throwing = true
        }
    }
}

class MockError: Error {}
