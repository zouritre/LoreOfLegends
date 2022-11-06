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
    func setSkins(caller: ChampionDetailAdapter, for champion: Champion) {
        self.selectedChampion = champion
        self.caller = caller
        skinsCount = champion.skins.count
        
        for skin in champion.skins {
            let splashUrl = URL(string: "https://ddragon.leagueoflegends.com/cdn/img/champion/splash/\(skin.fileName)")
            let centeredUrl = URL(string: "https://ddragon.leagueoflegends.com/cdn/img/champion/centered/\(skin.fileName)")
            
            Task {
                var splash: Data?
                var centered: Data?
                
                if let splashUrl {
                    do {
                        let (splashData, _) = try await URLSession.shared.data(from: splashUrl)
                        splash = splashData
                    }
                    catch {
                    }
                }
                if let centeredUrl {
                    let (centeredData, _) = try await URLSession.shared.data(from: centeredUrl)
                    centered = centeredData
                }
                
                var asset = skin
                
                asset.setSplash(with: splash)
                asset.setCenteredImage(with: centered)
                skins.append(asset)
            }
        }
    }
}

class RiotCdnApi {
    /// The adapter class that called a method of this class
    var caller: ChampionDetailAdapter?
    /// Champion to be processed with custom datas
    var selectedChampion: Champion?
    /// Skins of the selected champion
    var skins = [ChampionAsset]() {
        didSet {
            if skins.count == skinsCount {
                // Sort skins by name in ascending order
                skins.sort(by: { return $0.fileName < $1.fileName })
                
                // Set sorted skins array to selected champion skins array
                selectedChampion?.skins = skins
                
                guard let selectedChampion else { return }
                
                // Notify viewmodel of the selected champion after being processed
                caller?.caller?.championDataPublisher.send(selectedChampion)
            }
        }
    }
    /// Number of skins for the selected champion
    var skinsCount = 0
}
