//
//  ChampionListApi.swift
//  LoreOL
//
//  Created by Bertrand Dalleau on 13/10/2022.
//

import Foundation
import Combine

extension ChampionListApi: ChampionListDelegate {
    func getChampions(_ caller: ChampionList) {
        
        guard let championsData else {
            caller.sendChampionsData(result: .failure(ChampionListError.BundleReadFail))

            return
        }
        
        guard let response = try? JSONDecoder().decode(ChampionFullJsonDecodable.self, from: championsData) else {
            caller.sendChampionsData(result: .failure(ChampionListError.DecodingFail))

            return
        }
        
        for (_,championName) in response.keys {
            for (key, champInfo) in response.data {
                if key == championName {
                    var skins = [ChampionAsset]()
                    
                    for skin in champInfo.skins {
                        skins.append(ChampionAsset(fileName: "\(championName)_\(skin.num)", title: skin.name))
                    }
                    
                    champions.append(Champion(name: championName, title: champInfo.title, skins: skins, lore: champInfo.lore))
                    
                    break
                }
                else { continue }
            }
        }
        
        setIcon(for: champions)
        
        caller.sendChampionsData(result: .success(champions))
    }
}

class ChampionListApi {
    var champions = [Champion]()
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
    
    private func setIcon(for champions: [Champion]) {
        for (index, champion) in champions.enumerated() {
            
            let url = URL(string: "https://ddragon.leagueoflegends.com/cdn/img/champion/tiles/\(champion.name)_0.jpg")
            
            guard let url else { return }

            URLSession(configuration: .ephemeral).dataTask(with: url) { data, _, error in
                guard let data, error == nil else { return }
                
                self.champions[index].setIcon(with: data)
            }
        }
    }
    
//    private func setDataForImage(type: ChampionAssetType, for champions: inout [Champion]) {
//        var imageSubdirectory: String
//
//        switch type {
//        case .icon:
//            imageSubdirectory = "tiles"
//        case .splash:
//            imageSubdirectory = "splash"
//        case .centered:
//            imageSubdirectory = "centered"
//        }
//
//        for (index, champion) in champions.enumerated() {
//
//            let url = URL(string: "https://ddragon.leagueoflegends.com/cdn/img/champion/\(imageSubdirectory)/\(champion.name)_0.jpg")
//
//            guard let url else { return }
//
//            URLSession(configuration: .ephemeral).dataTask(with: url) { data, response, error in
//                guard let data, error == nil else { return }
//
//                switch type {
//                case .icon:
//                    champions[index].setIcon(with: data)
//                case .splash:
//                    champions[index]
//                case .centered:
//                    <#code#>
//                }
//
//            }
//        }
//    }
}
