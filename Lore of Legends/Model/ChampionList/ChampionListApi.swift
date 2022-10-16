//
//  ChampionListApi.swift
//  LoreOL
//
//  Created by Bertrand Dalleau on 13/10/2022.
//

import Foundation

extension ChampionListApi: ChampionListDelegate {
    func getChampions() {
        
        guard let championsData else {
            ChampionList().sendChampionsList(champions: nil, error: ChampionListError.BundleReadFail)

            return
        }
        
        guard let response = try? JSONDecoder().decode(ChampionFullJsonDecodable.self, from: championsData) else {
            ChampionList().sendChampionsList(champions: nil, error: ChampionListError.DecodingFail)

            return
        }
        
        var champs = [Champion]()
        
        for (_,championName) in response.keys {
            for (key, champInfo) in response.data {
                if key == championName {
                    var skins = [(num: Int, name: String)]()
                    
                    for skin in champInfo.skins {
                        skins.append((skin.num, skin.name))
                    }
                    
                    champs.append(Champion(name: championName, title: champInfo.title, skinIds: skins, lore: champInfo.lore))
                    
                    break
                }
                else { continue }
            }
        }
        
        ChampionList().sendChampionsList(champions: champs, error: nil)
    }
}

class ChampionListApi {
    /// Data object created from a JSON containing data for every champions
    private var championsData: Data? {
        let bundle = Bundle(for: Self.self)
        var localizedJsonUrl: URL?
            
        localizedJsonUrl = bundle.url(forResource: "championFull", withExtension: "json")
        
        if let localizedJsonUrl {
            return try? Data(contentsOf: localizedJsonUrl)
        }
        else { return nil }
    }
}
