//
//  ChampionListViewModel.swift
//  LoreOL
//
//  Created by Bertrand Dalleau on 12/10/2022.
//

import Foundation
import Combine

class ChampionListViewModel {
    
    @Published var champions: [Champion]
    @Published var championsDataError: Error?
    
    var championListModel: ChampionList
    var championsDataSubscriber: AnyCancellable?

    private init() {
        self.champions = []
        self.championListModel = ChampionList()
    }
    
    convenience init(api: ChampionListDelegate = ChampionListApi()) {
        self.init()
        self.championListModel.delegate = api
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
    
    func getChampions() {
        championListModel.delegate?.getChampions(championListModel)
    }
}
