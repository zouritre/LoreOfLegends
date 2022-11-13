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
    /// A bool indicating if the downloaded champions assets is already saved on the device locale storage
    private var isAssetSavedLocally: Bool {
        get {
            UserDefaults.standard.bool(forKey: UserDefaultKeys.isAssetSavedLocally.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultKeys.isAssetSavedLocally.rawValue)
        }
    }
    
    init(riotCdnapi: RiotCdnApiDelegate? = nil) {
        if let riotCdnapi {
            self.riotCdnApi = riotCdnapi
        }
    }
    
    func getChampions() {
        if isAssetSavedLocally {
            do {
                let champions = try coreDataApi.fetchChampions()
                
                championsPublisher.send(champions)
            }
            catch {
                championsPublisher.send(completion: .failure(error))
            }
        }
        else {
            Task {
                do {
                    let champions = try await riotCdnApi.getChampions(caller: self)
                    
                    championsPublisher.send(champions)
                    
                    try coreDataApi.save(champions: champions)
                    
                    isAssetSavedLocally = true
                }
                catch {
                    championsPublisher.send(completion: .failure(error))
                }
            }
        }
    }
    
    
}
