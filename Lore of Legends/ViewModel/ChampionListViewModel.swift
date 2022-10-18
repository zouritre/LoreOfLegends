//
//  ChampionListViewModel.swift
//  LoreOL
//
//  Created by Bertrand Dalleau on 12/10/2022.
//

import Foundation

protocol ChampionListViewModelDelegate {
    func championList(champions: [Champion]?, error: Error?)
}

class ChampionListViewModel {
    var champions: [Champion]? {
        willSet {
            delegate?.championList(champions: newValue, error: nil)
        }
    }
    
    var championsDataError: Error? {
        willSet {
            delegate?.championList(champions: nil, error: newValue)
        }
    }
    
    var delegate: ChampionListViewModelDelegate?
    var championListModel = ChampionList()

    init(api: ChampionListDelegate = ChampionListApi()) {
        self.champions = []
        championListModel.delegate = api
        
        let championListListenerName = Notification.Name("championsList")
        
        NotificationCenter.default.addObserver(self, selector: #selector(listenChampionsList(_:)), name: championListListenerName, object: nil)
    }
    
    @objc func listenChampionsList(_ sender: Notification) {
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
