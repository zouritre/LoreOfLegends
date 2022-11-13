//
//  Champion.swift
//  LoreOL
//
//  Created by Bertrand Dalleau on 12/10/2022.
//

import Foundation

/// Store information about a given champion in League
struct Champion: Codable {
    // Champion internal name
    var id: String
    /// Champion name
    var name: String
    /// Champion honorific name
    var title: String?
    /// Champion icon as a data object
    var icon: Data?
    /// Array repsenting every skins of this champion
    var skins: [ChampionAsset]?
    /// Lore of this champion
    var lore: String?
    
    /// Set the given data object to the icon property of this class
    /// - Parameter data: Data object representing this champion icon
    mutating func setIcon(with data: Data) {
        self.icon = data
    }
    
    mutating func setLore(with lore: String) {
        self.lore = lore
    }
    
    mutating func setTitle(with title: String) {
        self.title = title
    }
    
    mutating func setSkins(with assets: [ChampionAsset]) {
        self.skins = assets
    }
}
