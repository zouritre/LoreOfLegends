//
//  HomeScreenViewModel.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 10/11/2022.
//

import Foundation
import Combine

class HomeScreenViewModel {
    var champions: [Champion]?
    private var championsIconSubscriber: AnyCancellable?
    var homescreen = HomeScreen()
    
    init(riotCdnapi: RiotCdnApiDelegate? = nil) {
        if riotCdnapi != nil {
            homescreen = HomeScreen(riotCdnapi: riotCdnapi)
        }
        
        championsIconSubscriber = homescreen.championsPublisher.sink { [unowned self] icons in
         champions = icons
        }
    }
    func getChampions() {
        homescreen.getChampions()
    }
    
    func getChampionsName() {
        homescreen.getChampionsName()
    }
}
