//
//  ChampionAsset.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 23/10/2022.
//

import Foundation

struct ChampionAsset: Codable {
    var fileName: String
    var title: String
    var splash: Data = Data()
    var centered: Data = Data()
    
    mutating func setSplash(with data: Data) {
        self.splash = data
    }
    
    mutating func setCenteredImage(with data: Data) {
        self.centered = data
    }
}
