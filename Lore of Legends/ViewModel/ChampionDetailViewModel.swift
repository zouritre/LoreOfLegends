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
    
    var model: ChampionDetail
    var championDataSub: AnyCancellable?
    
    init() {
        self.model = ChampionDetail()
    }
    
    convenience init(model: ChampionDetail) {
        self.init()
        self.model = model
        self.championDataSub = model.championDataPublisher.sink(receiveValue: { champion in
            print("Champ arrived: ", champion)
            self.champion = champion
        })
    }
    
    func setSkinsForChampion(champion: Champion) {
        model.delegate.setSkinImages(caller: model, champion: champion)
    }
}
