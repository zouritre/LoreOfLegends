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
    var totalNumberOfChampions: Int?
    private var championsSubscriber: AnyCancellable?
    private var totalNumberOfChampionsSubscriber: AnyCancellable?
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
        
        totalNumberOfChampionsSubscriber = homescreen.totalNumberOfChampionsPublisher.sink(receiveValue: { [unowned self] total in
            totalNumberOfChampions = total
        })
    }
    
    func getChampions() {
        homescreen.getChampions()
    }
}
