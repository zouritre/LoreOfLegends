//
//  ChampionDetailViewModel.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 02/11/2022.
//

import Foundation
import Combine

class ChampionDetailViewModel {
    @Published var champion: Champion?
    
    let model = ChampionDetail()
    var championDataSub: AnyCancellable?
    
    init() {
        
    }
    
    convenience init(api: ChampionDetailDelegate = ChampionDetailAdapter()) {
        self.init()
        self.model.delegate = api
        self.championDataSub = model.championDataPublisher.sink(receiveValue: { champion in
            self.champion = champion
        })
    }
    
    func setSkinsForChampion(champion: Champion) {
        model.delegate?.setSkinImages(caller: model, champion: champion)
    }
}
