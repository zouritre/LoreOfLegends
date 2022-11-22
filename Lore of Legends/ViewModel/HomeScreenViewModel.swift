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
    @Published var patchVersion: String?
    
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
            self.champions = champions.sorted(by: { previousChampion, nextChampion in
                previousChampion.name < nextChampion.name
            })
        })
        
        // Assign publishers values to published properties
        homescreen.totalNumberOfChampionsPublisher.assign(to: &$totalNumberOfChampions)
        homescreen.iconsDownloadedPublisher.assign(to: &$iconsDownloaded)
        homescreen.newUpdatePublisher.assign(to: &$newUpdate)
        homescreen.patchVersionPublisher.assign(to: &$patchVersion)
    }
    
    func getChampions() async {
        await homescreen.getChampions()
    }
}
