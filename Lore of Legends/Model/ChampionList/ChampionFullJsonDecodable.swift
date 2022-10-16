//
//  ChampionFullJsonDecodable.swift
//  LoreOL
//
//  Created by Bertrand Dalleau on 14/10/2022.
//

import Foundation

struct ChampionFullJsonDecodable: Decodable {
    var data: [String:ChampionSpecificDecodable]
    var keys: [String:String]
}

struct ChampionSpecificDecodable: Decodable {
    var lore: String
    var title: String
    var skins: [ChampionSkinDecodable]
}

struct ChampionSkinDecodable: Decodable {
    var num: Int
    var name: String
}
