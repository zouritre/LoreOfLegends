//
//  ChampionListApi.swift
//  LoreOL
//
//  Created by Bertrand Dalleau on 13/10/2022.
//

import Foundation
import Combine

extension ChampionListAdapter: ChampionListDelegate {
    func getChampionsCount(caller: ChampionList) {
        Task {
            do {
                let decodable = try await getDecodableForChampionsData()
                
                caller.championsCountPublisher.send(decodable.keys.count)
            }
            catch {
                caller.championsDataSubject.send(completion: .failure(error))
            }
        }
    }
    
    func getChampions(_ caller: ChampionList) {
        self.caller = caller
        
        if isAssetSavedLocally {
            
        }
        else {
            Task {
                do {
                    let decodable = try await getDecodableForChampionsData()
                    
                    caller.championsCountPublisher.send(decodable.keys.count)
                    
                    let champions = createChampionsObjects(from: decodable)
                    
                    self.championsCount = champions.count
                    
                    setIcons(for: champions)
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

protocol ChampionListAdapterDelegate {
    func getLastestPatchVersion() async throws -> String
    
    func getSupportedLanguages() async throws -> [String]
    
    func retrieveChampionFullDataJson(url: URL) async throws -> Data
    
    func downloadImage(for champion: Champion) async throws -> Data
}

class ChampionListAdapter {
    // MARK: Vars
    /// Record every async task actually running
    @Published var onGoingTaskPublisher = 1
    @Published var champions = [Champion]()
    
    var delegate: ChampionListAdapterDelegate
    private var championsSubscriber: AnyCancellable?
    private var caller: ChampionList?
    private var championsCount: Int?
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
    
    // MARK: Init
    
    init(delegate: ChampionListAdapterDelegate = RiotCdnApi()) {
        self.delegate = delegate
        
        championsSubscriber = $champions.sink(receiveValue: { champions in
            guard let championsCount = self.championsCount else { return }
            
            if champions.count == championsCount {
                self.caller?.downloadedChampionCounterPub.send(championsCount)
                self.caller?.championsDataSubject.send(champions)
            }
            else {
                self.caller?.downloadedChampionCounterPub.send(championsCount)
            }
            
        })
//        taskSubscriber = $onGoingTaskPublisher.sink(receiveValue: { taskCount in
//            print("Task remaining: \(taskCount)")
//            if taskCount == 0 {
//                self.caller?.championsDataSubject.send(self.champions)
//
//                do {
////                    try self.saveChampionsLocally()
////
////                    self.isAssetSavedLocally = true
//
//                    self.caller?.championsDataSubject.send(completion: .finished)
//                }
//                catch {
//                    self.isAssetSavedLocally = false
//
//                    self.caller?.championsDataSubject.send(completion: .failure(error))
//                }
//
//                self.champions = []
//            }
//        })
    }
    
    
    // MARK: Methods
    
    func getDecodableForChampionsData() async throws -> ChampionFullJsonDecodable {
        let lastestPatchVersion = try await delegate.getLastestPatchVersion()
        let language = getLanguageForChampionsData()
        let url = try getChampionsDataUrl(patchVersion: lastestPatchVersion, localization: language.identifier)
        let json = try await delegate.retrieveChampionFullDataJson(url: url)
        let decodable = try decodeChampionDataJson(from: json)
        
        return decodable
    }
    
    func getLanguageForChampionsData() -> Locale {
        let selectedLanguage = UserDefaults.standard.string(forKey: "Lore Language")
        
        if let selectedLanguage {
            return Locale(identifier: selectedLanguage)
        }
        else {
            var language = String()
            
            if #available(iOS 16, *) {
                let localeLanguage = Locale.current.language.languageCode?.identifier
                
                guard let localeLanguage else { return Locale(identifier: "en_US")}
                
                language = localeLanguage
            } else {
                // Fallback on earlier versions
                let localeLanguage = Locale.current.languageCode
                
                guard let localeLanguage else { return Locale(identifier: "en_US")}
                
                language = localeLanguage
            }
            
            switch language {
            case "fr":
                return Locale(identifier: "fr_FR")
            default:
                return Locale(identifier: "en_US")
            }
        }
    }
    
    func setIcons(for champions: [Champion]) {
        for champion in champions {
            // Create a an async Task for every champion in the array
            Task {
                do {
                    // Download the icon as a Data object
                    let data = try await delegate.downloadImage(for: champion)
                    var champ = champion
                    champ.setIcon(with: data)
                    self.champions.append(champ)
                    
                }
                catch {
                    var champ = champion
                    champ.setIcon(with: Data())
                    self.champions.append(champ)
                }
                
            }
        }
    }
    
    func getChampionsDataUrl(patchVersion: String, localization: String) throws -> URL {
        let url = URL(string: "https://ddragon.leagueoflegends.com/cdn/\(patchVersion)/data/\(localization)/championFull.json")
        
        guard let url else {
            throw ChampionListError.badUrl
        }
        
        return url
    }
    
    func decodeChampionDataJson(from data: Data) throws -> ChampionFullJsonDecodable {
        do {
            let decodable = try JSONDecoder().decode(ChampionFullJsonDecodable.self, from: data)
            
            return decodable
        }
        catch {
            throw ChampionListError.DecodingFail
        }
    }
    
    func createChampionsObjects(from decodable: ChampionFullJsonDecodable) -> [Champion] {
        var champions = [Champion]()
        
        for (_,championName) in decodable.keys {
            for (key, champInfo) in decodable.data {
                if key == championName {
                    var imageName = champInfo.image.full
                    var skins = [ChampionAsset]()
                    
                    // Remove file extension
                    imageName.removeLast(4)
                    
                    for skin in champInfo.skins {
                        skins.append(ChampionAsset(fileName: "\(imageName)_\(skin.num)", title: skin.name))
                    }
                    
                    champions.append(Champion(name: champInfo.name, title: champInfo.title, imageName: imageName, skins: skins, lore: champInfo.lore))
                    
                    break
                }
                else { continue }
            }
        }
        
        return champions
    }
    
    private func saveChampionsLocally() throws {
//        let appDelegate = AppDelegate()
//        let context = appDelegate.persistentContainer.viewContext
        
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
