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
    
    var model = ChampionDetail()
    
    init() {
        self.championDataSub = self.model.championDataPublisher.sink(receiveValue: { champion in
            print("Champ arrived: ", champion)
            self.champion = champion
        })
    }
    
    var championDataSub: AnyCancellable?
    
    func setSkinsForChampion(champion: Champion) {
        model.delegate.setSkinImages(caller: model, champion: champion)
    }
}
