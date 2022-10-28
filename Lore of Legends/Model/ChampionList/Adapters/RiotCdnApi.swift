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

class RiotCdnApi {
    
}
