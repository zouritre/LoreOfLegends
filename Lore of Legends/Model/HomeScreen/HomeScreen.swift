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
            let championsWithIcon = try await riotCdnapi?.getChampionsIcon()
            guard let championsWithIcon else { return }
            
            championsPublisher.send(championsWithIcon)
        }
    }
    
    func getChampionsName() {
        Task {
            let championsWithName = try await riotCdnapi?.getChampionsName()
            
            guard let championsWithName else { return }
            
            championsPublisher.send(championsWithName)
        }
    }
    
    
}
