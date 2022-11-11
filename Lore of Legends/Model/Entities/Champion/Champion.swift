//
//  Champion.swift
//  LoreOL
//
//  Created by Bertrand Dalleau on 12/10/2022.
//

import Foundation

/// Store information about a given champion in League
struct Champion: Codable {
    /// Champion name
    var name: String
    /// Champion honorific name
    var title: String
    /// The skins images name for this champion according to Riot CDN
    var imageName: String
    /// Champion icon as a data object
    var icon: Data?
    /// Array repsenting every skins of this champion
    var skins: [ChampionAsset]
    /// Lore of this champion
    var lore: String
    
    /// Set the given data object to the icon property of this class
    /// - Parameter data: Data object representing this champion icon
    mutating func setIcon(with data: Data) {
        self.icon = data
    }
}
