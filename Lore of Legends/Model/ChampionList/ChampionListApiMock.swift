//
//  ChampionListApi.swift
//  LoreOL
//
//  Created by Bertrand Dalleau on 13/10/2022.
//

import Foundation

extension ChampionListApiMock: ChampionListDelegate {
    func getChampions(_ caller: ChampionList) {
        guard let champions else {
            caller.sendChampionsData(result: .failure(ChampionListError.DecodingFail))

            return
        }

        caller.sendChampionsData(result: .success(champions))
    }
}

class ChampionListApiMock {
    let champions:  [Champion]?
    
    init(champions: [Champion]?) {
        self.champions = champions
    }
}
