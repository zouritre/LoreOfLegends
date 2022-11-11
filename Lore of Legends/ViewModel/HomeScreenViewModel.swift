//
//  HomeScreenViewModel.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 10/11/2022.
//

import Foundation
import Combine

class HomeScreenViewModel {
    var championsIcon: [Data]?
    private var championsIconSubscriber: AnyCancellable?
    var homescreen = HomeScreen()
    
    init(riotCdnapi: RiotCdnApiDelegate? = nil) {
        if riotCdnapi != nil {
            homescreen = HomeScreen(riotCdnapi: riotCdnapi)
        }
        
        championsIconSubscriber = homescreen.championsIconPublisher.sink { [unowned self] icons in
         championsIcon = icons
        }
    }
    func getChampionsIcon() {
        homescreen.getChampionsIcon()
    }
}
