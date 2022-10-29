//
//  ChampionListApi.swift
//  LoreOL
//
//  Created by Bertrand Dalleau on 13/10/2022.
//

import Foundation
@testable import Lore_of_Legends

extension ChampionListApiMock: ChampionListDelegate {
    func getChampionsCount(caller: Lore_of_Legends.ChampionList) {
        caller.championsCountPublisher.send(1)
    }
    
    func getChampions(_ caller: ChampionList) {
        guard let champions else {
            caller.championsDataSubject.send(completion: .failure(ChampionListError.DecodingFail))

            return
        }

        caller.championsDataSubject.send(champions)
        caller.downloadedChampionCounterPub.send(1)
    }
}

/// API that mocks request for receiving the full champion list and theiricons
class ChampionListApiMock {
    let champions:  [Champion]?
    
    init(champions: [Champion]? = nil) {
        self.champions = champions
    }
}
