//
//  ChampionDetail.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 02/11/2022.
//

import Foundation
import Combine

protocol ChampionDetailDelegate {
    func setSkinImages(caller: ChampionDetail, champion: Champion)
}

class ChampionDetail {
    var delegate: ChampionDetailDelegate
    var championDataPublisher = PassthroughSubject<Champion, Never>()
    
    init(adapter: ChampionDetailDelegate = ChampionDetailAdapter()) {
        self.delegate = adapter
    }
}
