//
//  HomeScreen.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 11/11/2022.
//

import Foundation
import Combine

class HomeScreen {
    private var riotCdnApi: RiotCdnApiDelegate = RiotCdnApi()
    private var coreDataApi = CoreDataApi()
    var championsPublisher = PassthroughSubject<[Champion], Error>()
    var totalNumberOfChampionsPublisher = PassthroughSubject<Int?, Never>()
    var iconsDownloadedPublisher = CurrentValueSubject<Int?, Never>(0)
    var newUpdatePublisher = PassthroughSubject<String?, Never>()
    /// A bool indicating if the downloaded champions assets is already saved on the device locale storage
    var isAssetSavedLocally: Bool {
        get {
            UserDefaults.standard.bool(forKey: UserDefaultKeys.isAssetSavedLocally.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.isAssetSavedLocally.rawValue)
        }
    }
    
    var patchVersionForAssetsSaved: String? {
        get {
            UserDefaults.standard.string(forKey: UserDefaultKeys.patchVersionForAssetsSaved.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.patchVersionForAssetsSaved.rawValue)
        }
    }
    
    init(riotCdnapi: RiotCdnApiDelegate? = nil) {
        if let riotCdnapi {
            self.riotCdnApi = riotCdnapi
        }
    }
    
    func getChampions() {
        Task {
            if isAssetSavedLocally {
                do {
                    let champions = try coreDataApi.fetchChampions()
                    
                    championsPublisher.send(champions)
                }
                catch {
                    championsPublisher.send(completion: .failure(error))
                }
                
                if let (updateAvailable, newVersion) = try? await updateAvailable() {
                    if updateAvailable {
                        newUpdatePublisher.send(newVersion)
                    }
                }
            }
            else {
                do {
                    let champions = try await riotCdnApi.getChampions(caller: self)
                    
                    championsPublisher.send(champions)
                    
                    let currentPatch = try await riotCdnApi.getLastestPatchVersion()
                    
                    // Save the current patch version for the saved assets
                    patchVersionForAssetsSaved = currentPatch
                    
                    // Remove existing datas
                    try coreDataApi.removeChampionsDataFromStorage()
                    // Save new datas
                    try coreDataApi.save(champions: champions)
                    
                    isAssetSavedLocally = true
                }
                catch {
                    championsPublisher.send(completion: .failure(error))
                }
            }
        }
    }
    
    private func updateAvailable() async throws -> (newPatchAvailable: Bool, version: String?) {
        let newestPatchVersion = try await riotCdnApi.getLastestPatchVersion()
        
        guard let patchVersionForAssetsSaved else { throw UserDefaultsError.keyNotSet }
        
        let comparisonResult = patchVersionForAssetsSaved.compare(newestPatchVersion, options: .numeric)
        
        if comparisonResult == .orderedAscending {
            // New patch is available
            return (true, newestPatchVersion)
        }
        
        return (false, nil)
    }
}
