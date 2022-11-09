//
//  ChampionDetailAdapterMock.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 02/11/2022.
//

import Foundation
@testable import Lore_of_Legends

extension ChampionDetailAdapterMock: ChampionDetailDelegate {
    func setSkinImages(caller: Lore_of_Legends.ChampionDetail, champion: Lore_of_Legends.Champion) {
        let asset = ChampionAsset(fileName: "", title: "", splash: Data(), centered: Data())
        caller.championDataPublisher.send(Champion(name: "", title: "", imageName: "", skins: [asset], lore: ""))
    }
}
class ChampionDetailAdapterMock {
    
}
