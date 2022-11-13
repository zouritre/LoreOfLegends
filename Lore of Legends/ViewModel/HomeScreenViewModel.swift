//
//  HomeScreenViewModel.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 10/11/2022.
//

import Foundation
import Combine

class HomeScreenViewModel {
    @Published var champions: [Champion]?
    @Published var error: Error?
    @Published var totalNumberOfChampions: Int?
    @Published var iconsDownloaded: Int?
    @Published var newUpdate: String?
    
    private var championsSubscriber: AnyCancellable?
    private var totalNumberOfChampionsSubscriber: AnyCancellable?
    private var iconsDownloadedSubscriber: AnyCancellable?
    var homescreen = HomeScreen()
    
    init(riotCdnapi: RiotCdnApiDelegate? = nil) {
        if riotCdnapi != nil {
            homescreen = HomeScreen(riotCdnapi: riotCdnapi)
        }
        
        championsSubscriber = homescreen.championsPublisher.sink(receiveCompletion: { [unowned self] completion in
            switch completion {
            case .finished: return
            case .failure(let error): self.error = error
            }
        }, receiveValue: { [unowned self] champions in
            self.champions = champions
        })
        
        // Republish publisher values to totalNumberOfChampions property
        homescreen.totalNumberOfChampionsPublisher.assign(to: &$totalNumberOfChampions)
        // Republish publisher values to iconsDownloaded property
        homescreen.iconsDownloadedPublisher.assign(to: &$iconsDownloaded)
        // Republish publisher values to newUpdate property
        homescreen.newUpdatePublisher.assign(to: &$newUpdate)
    }
    
    func getChampions() {
        homescreen.getChampions()
    }
}
