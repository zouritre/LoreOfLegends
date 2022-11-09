//
//  ChampionListApi.swift
//  LoreOL
//
//  Created by Bertrand Dalleau on 13/10/2022.
//

import Foundation
@testable import Lore_of_Legends

extension ChampionListAdapterMock: ChampionListDelegate {
    func getChampions(_ caller: ChampionList) {
        guard let champions else {
            caller.championsDataSubject.send(completion: .failure(ChampionListError.DecodingFail))

            return
        }
        caller.totalChampionsCountPublisher.send(1)
        caller.championsDataSubject.send(champions)
        caller.downloadedChampionCounterPub.send(1)
        caller.isDownloadingPub.send(true)
    }
}

/// API that mocks request for receiving the full champion list and theiricons
class ChampionListAdapterMock {
    let champions:  [Champion]?
    
    init(champions: [Champion]? = nil) {
        self.champions = champions
    }
}
