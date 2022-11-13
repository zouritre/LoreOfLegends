//
//  CoreDataApi.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 13/11/2022.
//

import Foundation
import CoreData

class CoreDataApi {
    /// Save to Core Data every champions retrieved from Riot CDN
    /// - Parameters:
    ///   - champions: Array of Champion objects to saved locally
    ///   - context: Manage context to use for saving the objects
    func save(champions: [Champion], context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) throws {
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
            throw CoreDataApiError.castingFailed
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
            throw CoreDataApiError.castingFailed
        }

        for entry in storedData {
            // Remove all rows from ChampionData entity
            context.delete(entry)
        }

        // Save the context modifications
        try context.save()
    }
}
