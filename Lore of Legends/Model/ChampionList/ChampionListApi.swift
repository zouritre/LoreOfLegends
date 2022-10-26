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
        self.caller = caller
        
        if isAssetSavedLocally {
            
        }
        else {
            Task {
                do {
                    let lastestPatchVersion = try await UpdateService.getLastPatchVersion()
                    let url = try getUrlForChampionsData(for: lastestPatchVersion)
                    let json = try await retrieveChampionFullDataJson(url: url)
                    let decodable = try decodeChampionDataJson(from: json)
                    
                    self.champions = createChampionsObjects(from: decodable)
                    
                    onGoingTaskPublisher = self.champions.count
                    
                    setChampionsIcon()
                }
                catch {
                    // Force downloading assets again on next app start
                    isAssetSavedLocally = false
                    caller.championsDataSubject.send(completion: .failure(error))
                }
            }
        }
        
    }
}

class ChampionListApi {
    // MARK: Vars
    /// Record every async task actually running
    @Published var onGoingTaskPublisher = 1
    
    private var caller: ChampionList?
    /// A bool indicating if the downloaded champions assets is already saved on the device locale storage
    private var isAssetSavedLocally: Bool {
        get {
            UserDefaults.standard.bool(forKey: UserDefaultKeys.isAssetSavedLocally.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.isAssetSavedLocally.rawValue)
        }
    }
    private var taskSubscriber: AnyCancellable?
    /// List of every champion in League
    private var champions = [Champion]()
    
    // MARK: Init
    
    init() {
        taskSubscriber = $onGoingTaskPublisher.sink(receiveValue: { taskCount in
            print("Task remaining: \(taskCount)")
            if taskCount == 0 {
                self.caller?.championsDataSubject.send(self.champions)
                
                do {
//                    try self.saveChampionsLocally()
//                    
//                    self.isAssetSavedLocally = true
                    
                    self.caller?.championsDataSubject.send(completion: .finished)
                }
                catch {
                    self.isAssetSavedLocally = false
                    
                    self.caller?.championsDataSubject.send(completion: .failure(error))
                }
                
                self.champions = []
            }
        })
    }
    
    
    // MARK: Methods
    
    /// Aynchronously set every champion icon to their corresponding Champion object
    /// - Parameters:
    ///   - caller: Class responsible for sending the API data back to the view-model
    ///   - champions: An array containing every champion data
    private func setChampionsIcon() {
        for (index, _) in champions.enumerated() {
            // Create a an async Task for every champion in the array
            Task {
                // Download the icon as a Data object
                async let data = try downloadImage(championIndex: index)
                
                // Set the Data object to the matching Champion object
                try await self.champions[index].setIcon(with: data)
                
                onGoingTaskPublisher -= 1
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
    
    private func retrieveChampionFullDataJson(url: URL) async throws -> Data {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            return data
        }
        catch {
            throw error
        }
    }
    
    private func getUrlForChampionsData(for patchVersion: String) throws -> URL {
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
        
        let url = URL(string: "https://ddragon.leagueoflegends.com/cdn/\(patchVersion)/data/\(localeIdentifier)/championFull.json")
        
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
    
    private func saveChampionsLocally() throws {
        let appDelegate = AppDelegate()
        let context = appDelegate.persistentContainer.viewContext
        
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
