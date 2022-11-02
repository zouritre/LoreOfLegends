//
//  RiotCdnApi.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 27/10/2022.
//

import Foundation

extension RiotCdnApi: ChampionListAdapterDelegate {
    func getLastestPatchVersion() async throws -> String {
        return "12.20.1"
    }
    
    func getSupportedLanguages() async throws -> [String] {
        return [""]
    }
    
    func retrieveChampionFullDataJson(url: URL) async throws -> Data {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            return data
        }
        catch {
            throw error
        }
    }
    
    func downloadImage(for champion: Champion) async throws -> Data {
        let url = URL(string: "https://ddragon.leagueoflegends.com/cdn/img/champion/tiles/\(champion.imageName)_0.jpg")
        
        guard let url else { throw ChampionListError.badUrl }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            return data
        }
        catch {
            throw error
        }
    }
}

extension RiotCdnApi: ChampionDetailAdapterDelegate {
    func setSkins(for champion: Champion) async throws -> Champion {
        var champ = champion
        
        for (index, skin) in champion.skins.enumerated() {
            let splashUrl = URL(string: "https://ddragon.leagueoflegends.com/cdn/img/champion/splash/\(skin.fileName)")
            let centeredUrl = URL(string: "https://ddragon.leagueoflegends.com/cdn/img/champion/centered/\(skin.fileName)")
            
            guard let splashUrl else { throw ChampionListError.badUrl }
            guard let centeredUrl else { throw ChampionListError.badUrl }

            do {
                var skin = skin
                
                let (splashData, _) = try await URLSession.shared.data(from: splashUrl)
                
                skin.setSplash(with: splashData)
                
                let (centeredData, _) = try await URLSession.shared.data(from: centeredUrl)
                
                skin.setCenteredImage(with: centeredData)
                champ.skins.remove(at: index)
                champ.skins.append(skin)
            }
            catch {
                throw error
            }
        }
        
        return champ
    }
}

class RiotCdnApi {
    private func makeRequest(to: URL) {
        
    }
}
