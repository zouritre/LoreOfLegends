//
//  ChampionDetailViewModel.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 02/11/2022.
//

import Foundation
import Combine

class ChampionDetailViewModel {
    var champion: Champion?
    var viewmodel = ChampionDetail()
    var championSubscriber: AnyCancellable?
    
    init(api: RiotCdnApiDelegate? = nil) {
        if let api {
            self.viewmodel = ChampionDetail(customApi: api)
        }
        
        championSubscriber = viewmodel.championPublisher.sink { champion in
            self.champion = champion
        }
    }
    
    func getInfo(for champion: Champion) {
        viewmodel.getInfo(for: champion)
    }
}
