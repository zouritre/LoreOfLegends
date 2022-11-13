//
//  RiotCdnApi.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 27/10/2022.
//

import Foundation
import Combine

extension RiotCdnApi: RiotCdnApiDelegate {
    /// Get the lastest patch version for League
    /// - Returns: A string idicating the lastest patch versions
    func getLastestPatchVersion() async throws -> String {
        let url = URL(string: "https://ddragon.leagueoflegends.com/api/versions.json")
        let data = try await getData(at: url)
        let allPatchVersions = try JSONDecoder().decode([String].self, from: data)
        let lastestVersion = allPatchVersions[0]
        
        return lastestVersion
    }
    
    func setInfo(for champion: Champion) async throws -> Champion {
        let championWithTitle = try await setTitle(for: champion)
        let championWithTitleAndLore = try await setLore(for: championWithTitle)
        let championWithSkinsAndLoreAndTitle = try await setSkins(for: championWithTitleAndLore)
        
        return championWithSkinsAndLoreAndTitle
    }
    
    func setSkins(for champion: Champion) async throws -> Champion {
        let decodable = championFullJsonDecodable == nil ? try await getChampionsFullDataDecodable() : championFullJsonDecodable
        
        guard let decodable else { throw RiotCdnApiError.DecodingFail }
        
        // Decodable already exist locally
        for (championName, champInfo) in decodable.data {
            if championName == champion.id {
                let skins = await withTaskGroup(of: ChampionAsset.self) { taskgroup in
                    for skin in champInfo.skins {
                        var imageName = champInfo.image.full
                        
                        // Remove image extension
                        imageName.removeLast(4)
                        
                        let splashUrl = URL(string: "https://ddragon.leagueoflegends.com/cdn/img/champion/splash/\(imageName)_\(skin.num).jpg")
                        let centeredUrl = URL(string: "https://ddragon.leagueoflegends.com/cdn/img/champion/centered/\(imageName)_\(skin.num).jpg")
                        
                        taskgroup.addTask { [unowned self] in
                            
                            let splashData = try? await getData(at: splashUrl)
                            let centeredData = try? await getData(at: centeredUrl)
                            
                            return ChampionAsset(num: skin.num, title: skin.name, splash: splashData, centered: centeredData)
                        }
                    }
                    
                    var skins = [ChampionAsset]()
                    
                    for await asset in taskgroup {
                        skins.append(asset)
                    }
                    
                    skins.sort(by: { $0.num < $1.num })
                    
                    return skins
                }
                
                var champion = champion
                
                champion.setSkins(with: skins)
                
                return champion
            }
        }
        
        return champion
    }
    
    func setTitle(for champion: Champion) async throws -> Champion {
        let decodable = championFullJsonDecodable == nil ? try await getChampionsFullDataDecodable() : championFullJsonDecodable
        
        guard let decodable else { throw RiotCdnApiError.DecodingFail }
        
        // Decodable already exist locally
        for (championName, champInfo) in decodable.data {
            if championName == champion.id {
                var champion = champion
                champion.setTitle(with: champInfo.title)
                
                return champion
            }
        }
        
        return champion
        
    }
    
    func setLore(for champion: Champion) async throws -> Champion {
        let decodable = championFullJsonDecodable == nil ? try await getChampionsFullDataDecodable() : championFullJsonDecodable
        
        guard let decodable else { throw RiotCdnApiError.DecodingFail }
        
        // Decodable already exist locally
        for (championName, champInfo) in decodable.data {
            if championName == champion.id {
                var champion = champion
                champion.setLore(with: champInfo.lore)
                
                return champion
            }
        }
        
        return champion
    }
    
    func getChampions(caller: HomeScreen) async throws -> [Champion] {
        
        let decodable = championFullJsonDecodable == nil ? try await getChampionsFullDataDecodable() : championFullJsonDecodable
        
        guard let decodable else { throw RiotCdnApiError.DecodingFail }
        
        // Notify how many champions there is in League
        caller.totalNumberOfChampionsPublisher.send(decodable.keys.count)
        
        // Group every champion icon download in a task group and stop execution until they finish
        let champions = await withTaskGroup(of: Champion.self) { taskGroup in
            for (_, info) in decodable.data {
                // Icon name
                var imageName = info.image.full
                
                //Remove file extension
                imageName.removeLast(4)
                
                // Url to the icon
                let url = URL(string: "https://ddragon.leagueoflegends.com/cdn/img/champion/tiles/\(imageName)_0.jpg")
                
                taskGroup.addTask { [unowned self] in
                    // Get icon as data object from url
                    let data = try? await getData(at: url)
                    let champion = Champion(id: info.id, name: info.name, title: "", icon: data, skins: [], lore: "")
                    
                    if caller.iconsDownloadedPublisher.value != nil {
                        caller.iconsDownloadedPublisher.value! += 1
                    }
                    
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

protocol RiotCdnApiDelegate: AnyObject {
    func setInfo(for champion: Champion) async throws -> Champion
    func setSkins(for champion: Champion) async throws -> Champion
    func setTitle(for champion: Champion) async throws -> Champion
    func setLore(for champion: Champion) async throws -> Champion
    func getLastestPatchVersion() async throws -> String
    /// Retrieve every champions name and icon from Riot CDN
    /// - Returns: Array of Champion object with properties name and icon setted
    func getChampions(caller: HomeScreen) async throws -> [Champion]
    
    /// Return languages supported for the champions data
    /// - Returns: An array of languages
    func getSupportedLanguages() async throws -> [Locale]
}

class RiotCdnApi {
    
    static let shared = RiotCdnApi()
    
    var championFullJsonDecodable: ChampionFullJsonDecodable?
    
    /// Retrieve championFull.json file from Riot CDN and decodes it
    /// - Returns: Decoable of championFull.json
    private func getChampionsFullDataDecodable() async throws -> ChampionFullJsonDecodable {
        let patchVersion = try await getLastestPatchVersion()
        let locale = getLocalizationForChampionsData()
        let jsonUrl = try getChampionsFullJsonUrl(for: patchVersion, and: locale)
        let data = try await getData(at: jsonUrl)
        let decodable = try decodeChampionFullJson(from: data)
        
        // Locally store the decodable for reuse
        if championFullJsonDecodable == nil {
            championFullJsonDecodable = decodable
        }
        
        return decodable
    }
    
    /// Make a request to the provided url
    /// - Parameter url: URL of the request
    /// - Returns: Data object retrieved from the server response
    private func getData(at url: URL?) async throws -> Data {
        guard let url else { throw RiotCdnApiError.badUrl }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            return data
        }
        catch {
            throw error
        }
    }
    
    /// Returns a locale according to the devide language and region
    /// - Returns: Locale supported by Riot CDN
    private func getLocalizationForChampionsData() -> Locale {
        let loreLanguage = UserDefaults.standard.string(forKey: UserDefaultKeys.userSelectedLanguage.rawValue)
        
        if let loreLanguage {
            return Locale(identifier: loreLanguage)
        }
        else {
            var languageCode: String?
            
            if #available(iOS 16, *) {
                languageCode = Locale.current.language.languageCode?.identifier
            }
            else {
                languageCode = Locale.current.languageCode
            }
            
            switch languageCode {
            case "fr":
                return Locale(identifier: "fr_FR")
            default:
                return Locale(identifier: "en_US")
            }
        }
    }
    
    /// Get the URL for the most recent ChampionFull.json file from Riot CDN
    /// - Parameters:
    ///   - patchVersion: League patch version
    ///   - localization: Locale identifier representing the language in wich the data should be returned
    /// - Returns: An URL to ChampionFull.json file from Riot CDN
    private func getChampionsFullJsonUrl(for patchVersion: String, and localization: Locale) throws -> URL {
        let url = URL(string: "https://ddragon.leagueoflegends.com/cdn/\(patchVersion)/data/\(localization.identifier)/championFull.json")
        
        guard let url else {
            throw RiotCdnApiError.badUrl
        }
        
        return url
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
            throw RiotCdnApiError.DecodingFail
        }
    }
}
