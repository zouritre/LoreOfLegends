//
//  ChampionListApi.swift
//  LoreOL
//
//  Created by Bertrand Dalleau on 13/10/2022.
//

import Foundation

extension ChampionListApi: ChampionListDelegate {
    func getIcons(_ caller: ChampionList, for champions: [Champion]) {
        
    }
    
    func getChampions(_ caller: ChampionList) {
        
        guard let championsData else {
            caller.sendChampionsData(result: .failure(ChampionListError.BundleReadFail))

            return
        }
        
        guard let response = try? JSONDecoder().decode(ChampionFullJsonDecodable.self, from: championsData) else {
            caller.sendChampionsData(result: .failure(ChampionListError.DecodingFail))

            return
        }
        
        var champs = [Champion]()
        
        for (_,championName) in response.keys {
            for (key, champInfo) in response.data {
                if key == championName {
                    var skins = [ChampionSkin]()
                    
                    for skin in champInfo.skins {
                        skins.append(ChampionSkin(fileName: "\(championName)_\(skin.num)", title: skin.name))
                    }
                    
                    champs.append(Champion(name: championName, title: champInfo.title, skins: skins, lore: champInfo.lore))
                    
                    break
                }
                else { continue }
            }
        }
        
        caller.sendChampionsData(result: .success(champs))
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
