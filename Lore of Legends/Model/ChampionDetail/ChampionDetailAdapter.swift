//
//  ChampionDetailAdapter.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 02/11/2022.
//

import Foundation

protocol ChampionDetailAdapterDelegate {
    func setSkins(for champion: Champion) async throws -> Champion
}

extension ChampionDetailAdapter: ChampionDetailDelegate {
    func setSkinImages(caller: ChampionDetail, champion: Champion) {
        Task {
            var champ = champion
            
            do {
                champ = try await delegate.setSkins(for: champion)
            }
            catch {
            }
            caller.championDataPublisher.send(champ)
        }
    }
}

class ChampionDetailAdapter {
    var delegate: ChampionDetailAdapterDelegate
    
    init(delegate: ChampionDetailAdapterDelegate = RiotCdnApi()) {
        self.delegate = delegate
    }
}
