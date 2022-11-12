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
//                let champions = try fetchChampions()
//
//                // Send the array of champions retrieved from local storage
//                caller.championsDataSubject.send(champions)
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
//    func fetchChampions(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) throws -> [Champion] {
//        // fetch all data from ChampionData entity
//        let championsEncoded = try context.fetch(.init(entityName: "ChampionData"))
//
//        guard let championsEncoded = championsEncoded as? [ChampionData] else {
//            throw ChampionListError.CastingFailed
//        }
//
//        // initialise an empty array array of Champion objects
//        var champions = [Champion]()
//
//        for champion in championsEncoded {
//            guard let stringifiedData = champion.encodedData else {
//                continue
//            }
//
//            // Convert the stringifiedData string to a Data object
//            let data = Data(stringifiedData.utf8)
//
//            // Decode the data object to a Champion object
//            let decodedChampion = try JSONDecoder().decode(Champion.self, from: data)
//
//            // Append the newly retrieved Champion object to an array
//            champions.append(decodedChampion)
//        }
//
//        return champions
//    }
    
    /// Remove all data from ChampionData entity in Core Data
    /// - Parameter context: Context used to modify the persistent store
//    func removeChampionsDataFromStorage(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) throws {
//        // Fetch all data from ChampionData entity
//        let storedData = try context.fetch(.init(entityName: "ChampionData"))
//
//        guard let storedData = storedData as? [ChampionData] else {
//            throw ChampionListError.CastingFailed
//        }
//
//        for entry in storedData {
//            // Remove all rows from ChampionData entity
//            context.delete(entry)
//        }
//
//        // Save the context modifications
//        try context.save()
//    }
}
