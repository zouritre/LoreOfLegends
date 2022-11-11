//
//  RiotCdnApi.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 27/10/2022.
//

import Foundation
import Combine

extension RiotCdnApi: RiotCdnApiDelegate {
    func getChampions() async throws -> [Champion] {
        let decodable = try await getChampionsFullDataDecodable()
        
        let champions = await withTaskGroup(of: Champion.self) { taskGroup in
            for (_, info) in decodable.data {
                let url = URL(string: "https://ddragon.leagueoflegends.com/cdn/img/champion/tiles/\(info.image.full)_0.jpg")
                taskGroup.addTask { [unowned self]  in
                    let data = try? await getData(at: url)
                    let champion = Champion(name: info.name, title: "", imageName: "", icon: data, skins: [], lore: "")
                    return champion
                }
            }
            
            var champions = [Champion]()
            
            for await champion in taskGroup {
                champions.append(champion)
            }
            
            return champions
        }
        
        return champions
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
    /// Retrieve every champions name and icon from Riot CDN
    /// - Returns: Array of Champion object with properties name and icon setted
    func getChampions() async throws -> [Champion]
    
    /// Return languages supported for the champions data
    /// - Returns: An array of languages
    func getSupportedLanguages() async throws -> [Locale]
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
    
    private func getChampionsFullDataDecodable() async throws -> ChampionFullJsonDecodable {
        let patchVersion = try await getLastestPatchVersion()
        let locale = getLocalizationForChampionsData()
        let jsonUrl = try getChampionsFullJsonUrl(for: patchVersion, and: locale)
        let data = try await getData(at: jsonUrl)
        let decodable = try decodeChampionFullJson(from: data)
        
        return decodable
    }
    
    private func getData(at url: URL?) async throws -> Data {
        guard let url else { throw ChampionListError.badUrl }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            return data
        }
        catch {
            throw error
        }
    }
    
    private func getLocalizationForChampionsData() -> Locale {
        let deviceLocale = Locale.current
        
        switch deviceLocale.identifier {
        case "fr-FR": return deviceLocale
        default: return Locale(identifier: "en-US")
        }
    }
    
    /// Get the URL for the most recent ChampionFull.json file from Riot CDN
    /// - Parameters:
    ///   - patchVersion: League patch version
    ///   - localization: Locale identifier representing the language in wich the data should be returned
    /// - Returns: An URL to ChampionFull.json file from Riot CDN
    private func getChampionsFullJsonUrl(for patchVersion: String, and localization: Locale) throws -> URL {
        let locale = localization.identifier.replacingOccurrences(of: "-", with: "_")
        print(locale)
        let url = URL(string: "https://ddragon.leagueoflegends.com/cdn/\(patchVersion)/data/\(locale)/championFull.json")
        
        guard let url else {
            throw ChampionListError.badUrl
        }
        
        return url
    }
    
    /// Get the lastest patch version for League
    /// - Returns: A string idicating the lastest patch versions
    private func getLastestPatchVersion() async throws -> String {
        return "12.20.1"
    }
    
    /// Decode a data object to the given decodable format
    /// - Parameter data: Data to be decoded
    /// - Returns: Decocable object in wich the data should be decoded
    private func decodeChampionFullJson(from data: Data) throws -> ChampionFullJsonDecodable {
        do {
            let decodable = try JSONDecoder().decode(ChampionFullJsonDecodable.self, from: data)
            
            return decodable
        }
        catch {
            throw ChampionListError.DecodingFail
        }
    }
}
