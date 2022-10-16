//
//  ChampionListApi.swift
//  LoreOL
//
//  Created by Bertrand Dalleau on 13/10/2022.
//

import Foundation

extension ChampionListApiMock: ChampionListDelegate {
    func getChampions() {
        ChampionList().sendChampionsList(champions: champions)
    }
}

class ChampionListApiMock {
    let champions:  [Champion]
    
    init(champions: [Champion]?) {
        if let champions {
            self.champions = champions
        }
        else {
            self.champions = []
        }
    }
}
