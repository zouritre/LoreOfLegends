//
//  ChampionFullJsonDecodable.swift
//  LoreOL
//
//  Created by Bertrand Dalleau on 14/10/2022.
//

import Foundation

/// Represent the ChampionFull.json file retrieved from Riot CDN
struct ChampionFullJsonDecodable: Decodable {
    var data: [String:ChampionSpecificDecodable]
    var keys: [String:String]
}

struct ChampionSpecificDecodable: Decodable {
    var name: String
    var title: String
    var image: ChampionImageNameDecodable
    var lore: String
    var skins: [ChampionSkinDecodable]
}

struct ChampionImageNameDecodable: Decodable {
    var full: String
}

struct ChampionSkinDecodable: Decodable {
    var num: Int
    var name: String
}
