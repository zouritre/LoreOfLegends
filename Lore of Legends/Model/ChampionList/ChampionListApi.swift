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
            print("failed Data")
            
            return
        }
        
        guard let response = try? JSONDecoder().decode(ChampionFullJsonDecodable.self, from: championsData) else {
            print("failed decoding")
            
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
        
        print(champs)
        ChampionList().sendChampionsList(champions: champs)
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
