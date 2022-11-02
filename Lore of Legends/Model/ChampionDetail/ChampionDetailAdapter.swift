//
//  ChampionDetailAdapter.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 02/11/2022.
//

import Foundation

protocol ChampionDetailAdapterDelegate {
    func setIcon(for champion: Champion) async throws -> Champion
}

extension ChampionDetailAdapter: ChampionDetailDelegate {
    func setSkinImages(caller: ChampionDetail, champion: Champion) {
        Task {
            let champion = try? await delegate?.setIcon(for: champion)
            
            guard let champion else { return }
            
            caller.championDataPublisher.send(champion)
        }
    }
}

class ChampionDetailAdapter {
    var delegate: ChampionDetailAdapterDelegate?
    
    init(delegate: ChampionDetailAdapterDelegate? = RiotCdnApi()) {
        self.delegate = delegate
    }
}
