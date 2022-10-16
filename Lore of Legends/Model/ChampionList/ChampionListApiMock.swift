//
//  ChampionListApi.swift
//  LoreOL
//
//  Created by Bertrand Dalleau on 13/10/2022.
//

import Foundation

extension ChampionListApiMock: ChampionListDelegate {
    func getChampions() {
        guard let champions else {
            ChampionList().sendChampionsList(champions: nil, error: ChampionListError.DecodingFail)

            return
        }
        
        ChampionList().sendChampionsList(champions: champions, error: nil)
    }
}

class ChampionListApiMock {
    let champions:  [Champion]?
    
    init(champions: [Champion]?) {
        self.champions = champions
    }
}
