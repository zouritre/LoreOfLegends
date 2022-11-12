//
//  ChampionDetail.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 02/11/2022.
//

import Foundation
import Combine

class ChampionDetail {
    var api: RiotCdnApiDelegate? = RiotCdnApi()
    var championPublisher = PassthroughSubject<Champion, Never>()
    
    init(customApi: RiotCdnApiDelegate? = nil) {
        if let customApi {
            self.api = customApi
        }
    }
    
    func getInfo(for champion: Champion) {
        Task {
            let champion = try? await api?.setLore(for: champion)
            
            guard let champion else { return }
            
            championPublisher.send(champion)
        }
    }
}
