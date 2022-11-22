//
//  ChampionAsset.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 23/10/2022.
//

import Foundation

/// Store information about a skin for a given champion
struct ChampionAsset: Codable {
    // Skin number
    var num: Int
    /// Skin name
    var title: String
    /// Splash image as data object
    var splash: Data?
    /// Centered image as data object
    var centered: Data?
}
