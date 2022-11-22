//
//  ChampionDetail.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 02/11/2022.
//

import Foundation
import Combine

class ChampionDetail {
    private var api: RiotCdnApiDelegate? = RiotCdnApi.shared
    var championPublisher = PassthroughSubject<Champion?, Never>()
    
    init(customApi: RiotCdnApiDelegate? = nil) {
        if let customApi {
            self.api = customApi
        }
    }
    
    func setLore(for champion: Champion) async {
            let champion = try? await api?.setLore(for: champion)
            
            championPublisher.send(champion)
    }
    
    func setTitle(for champion: Champion) async {
            let champion = try? await api?.setTitle(for: champion)
            
            championPublisher.send(champion)
    }
    
    func setSkins(for champion: Champion) async {
            let champion = try? await api?.setSkins(for: champion)
            
            championPublisher.send(champion)
    }
    
    func setInfo(for champion: Champion) async {
            let champion = try? await api?.setInfo(for: champion)
            
            championPublisher.send(champion)
    }
    
}
