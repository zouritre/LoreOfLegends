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
        
        guard let championsData else {
            caller.championsDataSubject.send(completion: .failure(ChampionListError.BundleReadFail))

            return
        }
        
        guard let response = try? JSONDecoder().decode(ChampionFullJsonDecodable.self, from: championsData) else {
            caller.championsDataSubject.send(completion: .failure(ChampionListError.DecodingFail))

            return
        }
        
        // Create Champion object and set it's core properties
        for (_,championName) in response.keys {
            for (key, champInfo) in response.data {
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
        
        setIcon(caller, for: champions)
    }
}

class ChampionListApi {
    /// Record every async task actually running
    var onGoingTask = [Int]()
    /// List of every champion in League
    var champions = [Champion]()
    /// Data object created from a JSON containing data for every champions
    private var championsData: Data? {
        let bundle = Bundle(for: Self.self)
        var localizedJsonUrl: URL?
            
        localizedJsonUrl = bundle.url(forResource: "championFull", withExtension: "json")
        
        if let localizedJsonUrl {
            return try? Data(contentsOf: localizedJsonUrl)
        }
        else { return nil }
    }
    
    /// Aynchronously set every champion icon to their corresponding Champion object
    /// - Parameters:
    ///   - caller: Class responsible for sending the API data back to the view-model
    ///   - champions: An array containing every champion data
    private func setIcon(_ caller: ChampionList, for champions: [Champion]) {
        onGoingTask = []
        
        // Create a an async Task for every champion in the array
        for (index, _) in champions.enumerated() {
            onGoingTask.append(1)
            
            Task {
                let index = index
                
                do {
                    // Download the icon as a Data object
                    async let data = try downloadImage(championIndex: index)
                    
                    print("Data: \(try await data)")

                    // Set the Data object to the matching Champion object
                    self.champions[index].setIcon(with: try await data)
                    
                    self.taskDidFinish(caller)
                    print("Task \(index) finished")
                }
                catch {
                    print("\n\n\n\n\n\n\n ERROR")
                    self.taskDidFinish(caller)
                    
                    print("Task \(index) finished with error")
                    return
                }
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
        if self.onGoingTask.count > 0 {
            self.onGoingTask.removeLast()
            
            if onGoingTask.count == 0 {
                print("\n\n\n\n\n\n FIN. Task count: \(self.onGoingTask.count)")
                caller.championsDataSubject.send(champions)
                caller.championsDataSubject.send(completion: .finished)
                
                champions = []
            }
        }
    }
    
    private func retrieveChampionFullDataJson() async throws -> Data {
//        Locale.current.identifier
        let urlString = "https://ddragon.leagueoflegends.com/cdn/12.19.1/data/en_US/championFull.json"
        
        guard let url = URL(string: urlString) else { throw ChampionListError.GetJsonFailed}
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            return data
        }
        catch {
            throw error
        }
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
