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
    
    var viewmodel = ChampionDetail()
    var championSubscriber: AnyCancellable?
    
    init(api: RiotCdnApiDelegate? = nil) {
        if let api {
            self.viewmodel = ChampionDetail(customApi: api)
        }
        
        viewmodel.championPublisher.assign(to: &$champion)
    }
    
    func setLore(for champion: Champion) {
        viewmodel.setLore(for: champion)
    }
    
    func setTitle(for champion: Champion) {
        viewmodel.setTitle(for: champion)
    }
}
