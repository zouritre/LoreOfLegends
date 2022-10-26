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
        if didChangeLanguage || isAssetSavedLocally == false {
                Task {
                    do {
                        let json = try await retrieveChampionFullDataJson()
                        let decodable = try decodeChampionDataJson(from: json)
                        self.champions = createChampionsObjects(from: decodable)
                        
                        setIcon(caller, for: self.champions)
                        
                    }
                    catch {
                        caller.championsDataSubject.send(completion: .failure(error))
                    }
                }
        }
        if isAssetSavedLocally {
            
        }
        
    }
}

class ChampionListApi {
    /// A bool indicating if the downloaded champions assets is already saved on the device locale storage
    private var isAssetSavedLocally: Bool {
        get {
            UserDefaults.standard.bool(forKey: UserDefaultKeys.isAssetSavedLocally.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.isAssetSavedLocally.rawValue)
        }
    }
    private var didChangeLanguage: Bool {
        get {
            UserDefaults.standard.bool(forKey: UserDefaultKeys.didChangeLanguage.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.didChangeLanguage.rawValue)
        }
    }
    /// Record every async task actually running
    private var onGoingTask = Int()
    /// List of every champion in League
    private var champions = [Champion]()
    
    /// Aynchronously set every champion icon to their corresponding Champion object
    /// - Parameters:
    ///   - caller: Class responsible for sending the API data back to the view-model
    ///   - champions: An array containing every champion data
    private func setIcon(_ caller: ChampionList, for champions: [Champion]) {
        onGoingTask = champions.count
        
        for (index, _) in champions.enumerated() {
            // Create a an async Task for every champion in the array
            Task {
                // Download the icon as a Data object
                async let data = try downloadImage(championIndex: index)
                
                // Set the Data object to the matching Champion object
                try await self.champions[index].setIcon(with: data)
                
                self.taskDidFinish(caller)
                print("Task \(index) finished")
            }
        }
    }
    
    /// Download the icon of the champion at the index specified in the champions array
    /// - Parameter championIndex: Index from wich to retrieve the champion data
    /// - Returns: Data object corresponding to the image downloaded or an Error
    private func downloadImage(championIndex: Int) async throws -> Data {
        let url = URL(string: "https://ddragon.leagueoflegends.com/cdn/img/champion/tiles/\(self.champions[championIndex].name)_0.jpg")
        
        guard let url else { throw ChampionListError.badUrl }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            return data
        }
        catch {
            throw error
        }
        
    }
    
    /// Send the champion list to the model publisher
    /// - Parameter caller: Class responsible for notifying the API data to the view-model
    private func taskDidFinish(_ caller: ChampionList) {
        if self.onGoingTask > 0 {
            self.onGoingTask -= 1
            
            if onGoingTask == 0 {
                caller.championsDataSubject.send(self.champions)
                caller.championsDataSubject.send(completion: .finished)
                
                champions = []
            }
        }
    }
    
    private func retrieveChampionFullDataJson() async throws -> Data {
        do {
            let url = try getUrlByLocale()
            let (data, _) = try await URLSession.shared.data(from: url)
            
            return data
        }
        catch {
            throw error
        }
    }
    
    private func getUrlByLocale() throws -> URL {
        var localeIdentifier = String()
        
        switch Locale.current.languageCode {
        case "cs":
            localeIdentifier = "cs_CZ"
        case "de":
            localeIdentifier = "de_DE"
        case "el":
            localeIdentifier = "el_GR"
        case "en":
            localeIdentifier = "en_US"
        case "fr":
            localeIdentifier = "fr_FR"
        case "hu":
            localeIdentifier = "hu_HU"
        case "it":
            localeIdentifier = "it_IT"
        case "ja":
            localeIdentifier = "ja_JP"
        case "ko":
            localeIdentifier = "ko_KR"
        case "pl":
            localeIdentifier = "pl_PL"
        case "pt":
            localeIdentifier = "pt_BR"
        case "ro":
            localeIdentifier = "ro_RO"
        case "ru":
            localeIdentifier = "ru_RU"
        case "th":
            localeIdentifier = "th_TH"
        case "tr":
            localeIdentifier = "tr_TR"
        case "vn":
            localeIdentifier = "vn_VN"
        case "zh":
            localeIdentifier = "zh_CN"
        case .none:
            localeIdentifier = "en_US"
        case .some(_):
            localeIdentifier = "en_US"
        }
        
        let url = URL(string: "https://ddragon.leagueoflegends.com/cdn/12.19.1/data/\(localeIdentifier)/championFull.json")
        
        guard let url else {
            throw ChampionListError.GetJsonFailed
        }
        
        return url
    }
    
    private func decodeChampionDataJson(from data: Data) throws -> ChampionFullJsonDecodable {
        do {
            let decodable = try JSONDecoder().decode(ChampionFullJsonDecodable.self, from: data)
            
            return decodable
        }
        catch {
            throw ChampionListError.DecodingFail
        }
    }
    
    private func createChampionsObjects(from decodable: ChampionFullJsonDecodable) -> [Champion] {
        var champions = [Champion]()
        
        for (_,championName) in decodable.keys {
            for (key, champInfo) in decodable.data {
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
        
        return champions
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
