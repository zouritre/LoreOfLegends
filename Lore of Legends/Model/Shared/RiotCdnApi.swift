//
//  RiotCdnApi.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 27/10/2022.
//

import Foundation
import Combine

extension RiotCdnApi: RiotCdnApiDelegate {
    func getChampionsIcon() async -> [Data] {
        return []
    }
    
    func getLastestPatchVersion() async throws -> String {
        return "12.20.1"
    }
    
    func getSupportedLanguages() async throws -> [Locale] {
        let url = URL(string: "https://ddragon.leagueoflegends.com/cdn/languages.json")
        
        guard let url else { throw SettingsError.badUrl }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let languagesString = try JSONDecoder().decode([String].self, from: data)
        
        print(languagesString)
        var locales = [Locale]()
        
        languagesString.forEach { language in
            locales.append(Locale(identifier: language))
        }
        
        return locales
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
        self.skinsCount = champion.skins.count
        
        for skin in champion.skins {
            let splashUrl = URL(string: "https://ddragon.leagueoflegends.com/cdn/img/champion/splash/\(skin.fileName)")
            let centeredUrl = URL(string: "https://ddragon.leagueoflegends.com/cdn/img/champion/centered/\(skin.fileName)")
            
            Task {
                // A splash image as data object for the selected champion
                var splash: Data?
                // A centered image as data object for the selected champion
                var centered: Data?
                
                if let splashUrl {
                    let (splashData, _) = try await URLSession.shared.data(from: splashUrl)
                    splash = splashData
                }
                if let centeredUrl {
                    let (centeredData, _) = try await URLSession.shared.data(from: centeredUrl)
                    centered = centeredData
                }
                
                // A ChampionAsset object for the selected champion skin currently being processed
                var asset = skin
                
                asset.setSplash(with: splash)
                asset.setCenteredImage(with: centered)
                
                // Store the skin in memory while async tasks finishes
                skins.append(asset)
            }
        }
    }
}

protocol RiotCdnApiDelegate: AnyObject {
    func getChampionsIcon() async -> [Data]
    
    /// Get the lastest patch version for League
    /// - Returns: A string idicating the lastest patch versions
    func getLastestPatchVersion() async throws -> String
    
    /// Return languages supported for the champions data
    /// - Returns: An array of languages
    func getSupportedLanguages() async throws -> [Locale]
    
    /// Retrieve ChampionFull.json file from Riot CDN
    /// - Parameter url: URL of the json file
    /// - Returns: Data object representing the json file
    func retrieveChampionFullDataJson(url: URL) async throws -> Data
    
    /// Download the icon image of the given champion
    /// - Parameter champion: Champion for wich to retrieve data asynchronously
    /// - Returns: Data object representing the champion icon
    func downloadImage(for champion: Champion) async throws -> Data
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
