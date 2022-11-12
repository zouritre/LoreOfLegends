//
//  ChampionAsset.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 23/10/2022.
//

import Foundation

/// Store information about a skin for a given champion
struct ChampionAsset: Codable {
    /// Skin name
    var title: String
    /// Splash image as data object
    var splash: Data?
    /// Centered image as data object
    var centered: Data?
    
    /// Set the splash property with the provided data object
    /// - Parameter data: Data object to be set to the local property
    mutating func setSplash(with data: Data?) {
        self.splash = data
    }
    
    /// Set the centered property with the provided data object
    /// - Parameter data: Data object to be set to the local property
    mutating func setCenteredImage(with data: Data?) {
        self.centered = data
    }
}
