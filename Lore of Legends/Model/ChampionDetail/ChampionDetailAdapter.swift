//
//  ChampionDetailAdapter.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 02/11/2022.
//

import Foundation

protocol ChampionDetailAdapterDelegate {
    /// Retrieve and set skins images for the given champion
    /// - Parameters:
    ///   - caller: The class calling this method
    ///   - champion: Champion object for wich to retrieve skins images
    func setSkins(caller: ChampionDetailAdapter, for champion: Champion)
}

extension ChampionDetailAdapter: ChampionDetailDelegate {
    func setSkinImages(caller: ChampionDetail, champion: Champion) {
        self.caller = caller
        delegate.setSkins(caller: self, for: champion)
    }
}

class ChampionDetailAdapter {
    /// Class responsible for making async tasks
    var delegate: ChampionDetailAdapterDelegate
    /// Class wich called method of this instance
    var caller: ChampionDetail?
    
    init(delegate: ChampionDetailAdapterDelegate = RiotCdnApi()) {
        self.delegate = delegate
    }
}
