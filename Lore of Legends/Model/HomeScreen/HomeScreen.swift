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
    var championsIconPublisher = PassthroughSubject<[Data], Never>()
    
    init(riotCdnapi: RiotCdnApiDelegate? = nil) {
        if let riotCdnapi {
            self.riotCdnApi = riotCdnapi
            self.riotCdnapi = riotCdnapi
        }
        else {
            self.riotCdnapi = self.riotCdnApi
        }
    }
    
    func getChampionsIcon() {
        Task {
            let icons = await riotCdnapi?.getChampionsIcon()
            
            guard let icons else { return }
            
            championsIconPublisher.send(icons)
        }
    }
    
     
}
