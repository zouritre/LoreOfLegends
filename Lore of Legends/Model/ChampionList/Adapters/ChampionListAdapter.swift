//
//  ChampionListApi.swift
//  LoreOL
//
//  Created by Bertrand Dalleau on 13/10/2022.
//

import Foundation
import Combine
import CoreData

extension ChampionListAdapter: ChampionListDelegate {
    func getChampions(_ caller: ChampionList) {
        self.caller = caller
        
        if isAssetSavedLocally {
            caller.isDownloadingPub.send(false)
            
            do {
                let champions = try fetchChampions()
                
                print("Champions count: ", champions.count)
                caller.totalChampionsCountPublisher.send(champions.count)
                caller.downloadedChampionCounterPub.send(champions.count)
                caller.championsDataSubject.send(champions)
            }
            catch {
                // Force downloading assets again on next app start
                isAssetSavedLocally = false
                caller.championsDataSubject.send(completion: .failure(error))
            }
        }
        else {
            caller.isDownloadingPub.send(true)
            Task {
                do {
                    let decodable = try await getDecodableForChampionsData()
                    
                    self.championsCount = decodable.keys.count
                    
                    let champions = createChampionsObjects(from: decodable)
                    
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
    
    var champions = [Champion]() {
        willSet {
            self.caller?.downloadedChampionCounterPub.send(newValue.count)
            
            if newValue.count == championsCount {
                caller?.championsDataSubject.send(champions)
                do {
                    try saveChampionsLocally(champions: newValue)
                    
                    isAssetSavedLocally = true
                }
                catch {
                    caller?.championsDataSubject.send(completion: .failure(error))
                    
                    isAssetSavedLocally = false
                }
            }
        }
    }
    
    var delegate: ChampionListAdapterDelegate
    private var championsSubscriber: AnyCancellable?
    var caller: ChampionList?
    var championsCount = Int() {
        willSet {
            caller?.totalChampionsCountPublisher.send(newValue)
        }
    }
    /// A bool indicating if the downloaded champions assets is already saved on the device locale storage
    private var isAssetSavedLocally: Bool {
        get {
            UserDefaults.standard.bool(forKey: UserDefaultKeys.isAssetSavedLocally.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.isAssetSavedLocally.rawValue)
        }
    }
    
    // MARK: Init
    
    init(delegate: ChampionListAdapterDelegate = RiotCdnApi()) {
        self.delegate = delegate
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
    
    func saveChampionsLocally(champions: [Champion], context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) throws {
        for champion in champions {
            do {
                let encodedData = try JSONEncoder().encode(champion)
                let stringifiedData = String(data: encodedData, encoding: .utf8)
                let championEncoded = ChampionData(context: context)
                
                championEncoded.encodedData = stringifiedData
                
                try context.save()
            }
            catch {
                throw error
            }
        }
    }
    
    func fetchChampions(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) throws -> [Champion] {
        do {
            let championsEncoded = try context.fetch(.init(entityName: "ChampionData"))
            
            guard let championsEncoded = championsEncoded as? [ChampionData] else {
                print("Bad casting")
                throw ChampionListError.CastingFailed
            }
            
            var champions = [Champion]()
            
            for champion in championsEncoded {
                guard let stringifiedData = champion.encodedData else {
                    throw ChampionListError.NoDataFetchedForRow
                }
                
                let data = Data(stringifiedData.utf8)
                
                let decodedChampion = try JSONDecoder().decode(Champion.self, from: data)
                
                champions.append(decodedChampion)
            }
            
            return champions
        }
        catch {
            throw error
        }
    }
    
    func removeChampionsDataFromStorage(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) throws {
        let storedData = try context.fetch(.init(entityName: "ChampionData"))
        
        guard let storedData = storedData as? [ChampionData] else {
            throw ChampionListError.CastingFailed
        }
        
        for entry in storedData {
            context.delete(entry)
        }
        
        try context.save()
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
