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
    @Published var championIcons: [ChampionAsset]
    
    var championListModel: ChampionList
    var championsDataSubscriber: AnyCancellable?
    var championIconsSubscriber: AnyCancellable?

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
        self.championIconsSubscriber = championListModel.championIconsPublisher.sink { assets in
            print("received \(assets.count) data")
            self.championIcons = assets
        }
    }
    
    func getChampions() {
        championListModel.delegate?.getChampions(championListModel)
    }
}
