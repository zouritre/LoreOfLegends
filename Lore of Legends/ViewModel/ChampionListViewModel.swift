//
//  ChampionListViewModel.swift
//  LoreOL
//
//  Created by Bertrand Dalleau on 12/10/2022.
//

import Foundation
import Combine

/// Object that manages the list of every champion
class ChampionListViewModel {
    
    /// A list of champion
    @Published var champions = [Champion]()
    /// An error thrown when fetching the list of champion from the API
    @Published var championsDataError: Error?
    @Published var championsCount = 0
    
    /// Class responsible for processing and sending the data received by the view-model
    var championListModel: ChampionList
    /// Subscriber that receive data from the model
    var championDataSubscriber: AnyCancellable?
    
    init(api: ChampionListDelegate = ChampionListAdapter()) {
        self.champions = []
        self.championListModel = ChampionList(api: api)
        // Implement the subscriber to process the data sent from the model
        self.championDataSubscriber = championListModel.championDataSubject.sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                return
            case .failure(let error):
                self.championsDataError = error
            }
        }, receiveValue: { champion in
            self.champions.append(champion)
        })
    }
    
    func getChampionsCount() async {
        do {
            championsCount = try await championListModel.delegate.getChampionsCount()
        }
        catch {
            championsDataError = error
        }
    }
    
    /// Request the full champion list from the API
    func getChampions() {
        championListModel.delegate.getChampions(championListModel)
    }
}
