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
    @Published var championIcons: [Data]
    
    var championListModel: ChampionList
    var championsDataSubscriber: AnyCancellable?
    var championIconsSubscriber: AnyCancellable?
    var asub: AnyCancellable?

    private init() {
        self.champions = []
        self.championListModel = ChampionList()
        self.championIcons = []
    }
    
    convenience init(api: ChampionListDelegate = ChampionListApi()) {
        self.init()
        self.championListModel.delegate = api
        self.championsDataSubscriber = championListModel.championsDataPublisher.sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                return
            case .failure(let error):
                self.championsDataError = error
            }
        }, receiveValue: { champions in
            self.champions = champions
        })
        self.championIconsSubscriber = championListModel.championIconsPublisher.sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                return
            case .failure(let error):
                self.championsDataError = error
            }
        }, receiveValue: { data in
            self.championIcons = data
        })
    }
    
    func getChampions() {
        championListModel.delegate?.getChampions(championListModel)
    }
    
    func getChampionIcons() {
        championListModel.delegate?.getIcons(championListModel, for: champions)
    }
}
