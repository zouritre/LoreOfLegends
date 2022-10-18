//
//  ChampionListViewModel.swift
//  LoreOL
//
//  Created by Bertrand Dalleau on 12/10/2022.
//

import Foundation

class ChampionListViewModel {
    
    @Published var champions: [Champion]?
    @Published var championsDataError: Error?
    
    var championListModel = ChampionList()
    var championsDataPublisher: NotificationCenter.Publisher
    var championsDataSubscriber: Any?

    private init() {
        let championListListenerName = Notification.Name("championsData")
        
        self.championsDataPublisher = NotificationCenter.default.publisher(for: championListListenerName)
    }
    
    convenience init(api: ChampionListDelegate = ChampionListApi()) {
        self.init()
        self.champions = []
        self.championListModel.delegate = api
        self.championsDataSubscriber = championsDataPublisher.sink(receiveValue: { notification in
            self.processChampionsData(notification)
        })
    }
    
    private func processChampionsData(_ sender: Notification) {
        guard let sender = sender.userInfo else {
            championsDataError = ChampionListError.NotificationNoData
            return
        }
        
        if let champions = sender["list"] as? [Champion] {
            self.champions = champions
        }
        else {
            self.champions = nil
        }
        
        if let error = sender["error"] as? Error {
            self.championsDataError = error
        }
        else {
            self.championsDataError = nil
        }
    }
    
    func getChampions() {
        championListModel.delegate?.getChampions()
    }
}
