//
//  ChampionDetail.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 02/11/2022.
//

import Foundation
import Combine

protocol ChampionDetailDelegate {
    /// Retrieve and set skins images for the given champion
    /// - Parameters:
    ///   - caller: The class calling this method
    ///   - champion: Champion object for wich to retrieve skins images
    func setSkinImages(caller: ChampionDetail, champion: Champion)
}

class ChampionDetail {
    /// Adapter responsible for processing a given champion skins
    var delegate: ChampionDetailDelegate
    /// Publisher used to send Champion object processed by the delegate
    var championDataPublisher = PassthroughSubject<Champion, Never>()
    
    init(adapter: ChampionDetailDelegate = ChampionDetailAdapter()) {
        self.delegate = adapter
    }
}
