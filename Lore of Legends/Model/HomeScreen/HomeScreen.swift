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
    var championsPublisher = PassthroughSubject<[Champion], Error>()
    
    init(riotCdnapi: RiotCdnApiDelegate? = nil) {
        if let riotCdnapi {
            self.riotCdnApi = riotCdnapi
        }
    }
    
    func getChampions() {
        Task {
            do {
                let champions = try await riotCdnApi.getChampions()
                
                championsPublisher.send(champions)
            }
            catch {
                championsPublisher.send(completion: .failure(error))
            }
        }
    }
    
    
}
