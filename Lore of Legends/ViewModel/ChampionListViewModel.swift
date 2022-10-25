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
    @Published var champions: [Champion]
    /// An error thrown when fetching the list of champion from the API
    @Published var championsDataError: Error?
    
    /// Class responsible for processing and sending the data received by the view-model
    var championListModel: ChampionList
    /// Subscriber that receive data from the model
    var championsDataSubscriber: AnyCancellable?

    private init() {
        self.champions = []
        self.championListModel = ChampionList()
    }
    
    convenience init(api: ChampionListDelegate = ChampionListApi()) {
        self.init()
        // Inject the given API
        self.championListModel.delegate = api
        // Implement the subscriber to process the data sent from the model
        self.championsDataSubscriber = championListModel.championsDataSubject.sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                return
            case .failure(let error):
                self.championsDataError = error
            }
        }, receiveValue: { champions in
            self.champions = champions
        })
    }
    
    /// Request the full champion list from the API
    func getChampions() {
        championListModel.delegate?.getChampions(championListModel)
    }
}
