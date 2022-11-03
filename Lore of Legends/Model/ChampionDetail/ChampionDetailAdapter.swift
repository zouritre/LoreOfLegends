//
//  ChampionDetailAdapter.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 02/11/2022.
//

import Foundation

protocol ChampionDetailAdapterDelegate {
    func setSkins(caller: ChampionDetailAdapter, for champion: Champion)
}

extension ChampionDetailAdapter: ChampionDetailDelegate {
    func setSkinImages(caller: ChampionDetail, champion: Champion) {
        self.caller = caller
        delegate.setSkins(caller: self, for: champion)
    }
}

class ChampionDetailAdapter {
    var delegate: ChampionDetailAdapterDelegate
    var caller: ChampionDetail?
    
    init(delegate: ChampionDetailAdapterDelegate = RiotCdnApi()) {
        self.delegate = delegate
    }
}
