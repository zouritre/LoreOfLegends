//
//  HomeScreen.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 11/11/2022.
//

import Foundation
import Combine

class HomeScreen {
    private var riotCdnApi: RiotCdnApiDelegate = RiotCdnApi()
    private weak var riotCdnapi: RiotCdnApiDelegate?
    var championsPublisher = PassthroughSubject<[Champion], Never>()
    
    init(riotCdnapi: RiotCdnApiDelegate? = nil) {
        if let riotCdnapi {
            self.riotCdnApi = riotCdnapi
            self.riotCdnapi = riotCdnapi
        }
        else {
            self.riotCdnapi = self.riotCdnApi
        }
    }
    
    func getChampions() {
        Task {
            let champions = try await riotCdnapi?.getChampions()
            
            guard let champions else { return }
            
            championsPublisher.send(champions)
        }
    }
    
    
}
