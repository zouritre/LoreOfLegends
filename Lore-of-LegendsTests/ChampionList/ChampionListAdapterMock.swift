//
//  ChampionListApi.swift
//  LoreOL
//
//  Created by Bertrand Dalleau on 13/10/2022.
//

import Foundation
@testable import Lore_of_Legends

extension ChampionListAdapterMock: ChampionListDelegate {
    func getChampionsCount() async throws -> Int {
        return 1
    }
    
    func getChampions(_ caller: ChampionList) {
        guard let champion else {
            caller.championDataSubject.send(completion: .failure(ChampionListError.DecodingFail))

            return
        }

        caller.championDataSubject.send(champion)
    }
}

/// API that mocks request for receiving the full champion list and theiricons
class ChampionListAdapterMock {
    let champion:  Champion?
    
    init(champion: Champion? = nil) {
        self.champion = champion
    }
    
    func setIcons(caller: ChampionList,for champions: [Champion]) {
        caller.championDataSubject.send(champions[0])
    }
}
