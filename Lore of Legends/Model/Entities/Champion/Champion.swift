//
//  Champion.swift
//  LoreOL
//
//  Created by Bertrand Dalleau on 12/10/2022.
//

import Foundation

struct Champion {
    var name: String
    var title: String
    var imageName: String
    var icon: Data = Data()
    var skins: [ChampionAsset]
    var lore: String
    
    mutating func setIcon(with data: Data) {
        self.icon = data
    }
}
