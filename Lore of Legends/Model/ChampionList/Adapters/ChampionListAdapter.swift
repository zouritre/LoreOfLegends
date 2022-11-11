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
            // Notify the viewmodel that no download is pending
            caller.isDownloadingPub.send(false)
            
            do {
                // Retrieve all champions from Riot CDN
                let champions = try fetchChampions()
                
                // Send the array of champions retrieved from local storage
                caller.championsDataSubject.send(champions)
            }
            catch {
                // Force downloading assets again on next app start
                isAssetSavedLocally = false
                // Notify an error
                caller.championsDataSubject.send(completion: .failure(error))
            }
        }
        else {
            // Notify that a download is in progress
//            caller.isDownloadingPub.send(true)
//
//            Task {
//                do {
//                    // Remove already stored champions data to avoid duplicating
//                    try removeChampionsDataFromStorage()
//
//                    let decodable = try await getDecodableForChampionsData()
//
//                    // Store in memory the total number of champions
//                    self.championsCount = decodable.keys.count
//
//                    let champions = createChampionsObjects(from: decodable)
//
//                    setIcons(for: champions)
//                }
//                catch {
//                    // Force downloading assets again on next app start
//                    isAssetSavedLocally = false
//
//                    // Notify the error
//                    caller.championsDataSubject.send(completion: .failure(error))
//                }
//            }
        }
        
    }
}

class ChampionListAdapter {
    // MARK: Vars
    
    /// Champions retrieved from Riot CDN
    var champions = [Champion]() {
        willSet {
            // Notify the number of champions retrieved at this time
            self.caller?.downloadedChampionCounterPub.send(newValue.count)
            
            if newValue.count == championsCount {
                // Send the champions retrieved from API
                caller?.championsDataSubject.send(champions)
                
                do {
                    try saveChampionsLocally(champions: newValue)
                    
                    // Ensure the asset will not be downloaded again on next app start
                    isAssetSavedLocally = true
                }
                catch {
                    // Notify the error
                    caller?.championsDataSubject.send(completion: .failure(error))
                    
                    // Ensure assets will be downloaded again on next app start
                    isAssetSavedLocally = false
                }
            }
        }
    }
    
    /// Class responsible for making request to Riot CDN
    var delegate: RiotCdnApiDelegate
    /// Class instance that call this class methods
    var caller: ChampionList?
    /// Total number of champions in League
    var championsCount = Int() {
        willSet {
            // Notify the number of champions in League
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
    
    init(delegate: RiotCdnApiDelegate = RiotCdnApi()) {
        self.delegate = delegate
    }
    
    
    // MARK: Methods
    
    /// Retrieve ChampionFull.json file from Riot CDNs
    /// - Returns: A decodable object representing the json file retrieve form API
//    func getDecodableForChampionsData() async throws -> ChampionFullJsonDecodable {
//        let lastestPatchVersion = try await delegate.getLastestPatchVersion()
//        let language = getLanguageForChampionsData()
//        let url = try getChampionsDataUrl(patchVersion: lastestPatchVersion, localization: language.identifier)
//        let json = try await delegate.retrieveChampionFullDataJson(url: url)
//        let decodable = try decodeChampionDataJson(from: json)
//
//        return decodable
//    }
    
    /// Get the languages to use for champion's lore display
    /// - Returns: A locale for the language to use
    func getLanguageForChampionsData() -> Locale {
        // Check if the user have already chosen a language
        let selectedLanguage = UserDefaults.standard.string(forKey: "Lore Language")
        
        if let selectedLanguage {
            // Return the user selected language
            return Locale(identifier: selectedLanguage)
        }
        else {
            // Return a locale for either french or english depending of the device current locale
            
            /// Locale identifier of the device
            var language = String()
            
            if #available(iOS 16, *) {
                // Current locale for the device
                let localeLanguage = Locale.current.language.languageCode?.identifier
                
                guard let localeLanguage else { return Locale(identifier: "en_US")}
                
                language = localeLanguage
            } else {
                // Fallback on earlier versions
                
                // Current locale for the device
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
    
    /// Download icons for provided champions
    /// - Parameter champions: Array of champions for wich to download their icons
    func setIcons(for champions: [Champion]) {
        for champion in champions {
            // Create a an async Task for every champion in the array
            Task {
                do {
                    let data = try await delegate.downloadImage(for: champion)
                    // Create a mutable copy of the champion
                    var champ = champion
                    
                    champ.setIcon(with: data)
                    self.champions.append(champ)
                    
                }
                catch {
                    // Create a mutable copy of the champion
                    var champ = champion
                    
                    champ.setIcon(with: Data())
                    self.champions.append(champ)
                }
                
            }
        }
    }
    
    /// Get the URL for the most recent ChampionFull.json file from Riot CDN
    /// - Parameters:
    ///   - patchVersion: League patch version
    ///   - localization: Locale identifier representing the language in wich the data should be returned
    /// - Returns: An URL to ChampionFull.json file from Riot CDN
    func getChampionsDataUrl(patchVersion: String, localization: String) throws -> URL {
        let url = URL(string: "https://ddragon.leagueoflegends.com/cdn/\(patchVersion)/data/\(localization)/championFull.json")
        
        guard let url else {
            throw ChampionListError.badUrl
        }
        
        return url
    }
    
    /// Decode a data object to the given decodable format
    /// - Parameter data: Data to be decoded
    /// - Returns: Decocable object in wich the data should be decoded
    func decodeChampionDataJson(from data: Data) throws -> ChampionFullJsonDecodable {
        do {
            let decodable = try JSONDecoder().decode(ChampionFullJsonDecodable.self, from: data)
            
            return decodable
        }
        catch {
            throw ChampionListError.DecodingFail
        }
    }
    
    /// Create an array of Champion objects from the given decodable object
    /// - Parameter decodable: Decodable object containing data for all champions in League
    /// - Returns: Array of Champion object with their respective datas
    func createChampionsObjects(from decodable: ChampionFullJsonDecodable) -> [Champion] {
        // Initialise an empty array of Champion objects
        var champions = [Champion]()
        
        for (_,championName) in decodable.keys {
            for (key, champInfo) in decodable.data {
                if key == championName {
                    // Retrieve data for this champion
                    
                    // Name of the image assets
                    var imageName = champInfo.image.full
                    // Initliase en empty an array of ChampionAsset objects
                    var skins = [ChampionAsset]()
                    
                    // Remove file extension
                    imageName.removeLast(4)
                    
                    for skin in champInfo.skins {
                        // Create a ChampionAsset object and append it to the skins array
                        skins.append(ChampionAsset(fileName: "\(imageName)_\(skin.num).jpg", title: skin.name))
                    }
                    
                    // Create a Champion object and append to it the skins array
                    champions.append(Champion(name: champInfo.name, title: champInfo.title, imageName: imageName, skins: skins, lore: champInfo.lore))
                    
                    // Break current loop after a Champion object has successfully been created
                    break
                }
                else { continue }
            }
        }
        
        return champions
    }
    
    /// Save to Core Data every champions retrieved from Riot CDN
    /// - Parameters:
    ///   - champions: Array of Champion objects to saved locally
    ///   - context: Manage context to use for saving the objects
    func saveChampionsLocally(champions: [Champion], context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) throws {
        for champion in champions {
            do {
                // Create a data object from the Champion object
                let encodedData = try JSONEncoder().encode(champion)
                // Create a string form the data object representing the Champion
                let stringifiedData = String(data: encodedData, encoding: .utf8)
                // Initialise ChampionData entity with the given context
                let championEncoded = ChampionData(context: context)
                
                // Set the entity "encodedData" property with the stringifiedData
                championEncoded.encodedData = stringifiedData
                
                // Save the context to the persistent store
                try context.save()
            }
            catch {
                throw error
            }
        }
    }
    
    /// Retrieve the Champion object saved to Core Data
    /// - Parameter context: Context to use for fetching from Core Data
    /// - Returns: Champion object retrieved from persistent store
    func fetchChampions(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) throws -> [Champion] {
        // fetch all data from ChampionData entity
        let championsEncoded = try context.fetch(.init(entityName: "ChampionData"))
        
        guard let championsEncoded = championsEncoded as? [ChampionData] else {
            throw ChampionListError.CastingFailed
        }
        
        // initialise an empty array array of Champion objects
        var champions = [Champion]()
        
        for champion in championsEncoded {
            guard let stringifiedData = champion.encodedData else {
                continue
            }
            
            // Convert the stringifiedData string to a Data object
            let data = Data(stringifiedData.utf8)
            
            // Decode the data object to a Champion object
            let decodedChampion = try JSONDecoder().decode(Champion.self, from: data)
            
            // Append the newly retrieved Champion object to an array
            champions.append(decodedChampion)
        }
        
        return champions
    }
    
    /// Remove all data from ChampionData entity in Core Data
    /// - Parameter context: Context used to modify the persistent store
    func removeChampionsDataFromStorage(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) throws {
        // Fetch all data from ChampionData entity
        let storedData = try context.fetch(.init(entityName: "ChampionData"))
        
        guard let storedData = storedData as? [ChampionData] else {
            throw ChampionListError.CastingFailed
        }
        
        for entry in storedData {
            // Remove all rows from ChampionData entity
            context.delete(entry)
        }
        
        // Save the context modifications
        try context.save()
    }
}
