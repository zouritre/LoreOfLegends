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
    
    func setLore(for champion: Champion) async {
        await viewmodel.setLore(for: champion)
    }
    
    func setTitle(for champion: Champion) async {
        await viewmodel.setTitle(for: champion)
    }
    
    func setSkins(for champion: Champion) async {
        await viewmodel.setSkins(for: champion)
    }
    
    func setInfo(for champion: Champion) async {
        await viewmodel.setInfo(for: champion)
    }
}
