//
//  UpdateService.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 26/10/2022.
//

import Foundation

class UpdateService {
    static func getLastPatchVersion() async throws -> String {
        do {
            let url = URL(string: "https://ddragon.leagueoflegends.com/api/versions.json")
            
            guard let url else { throw UpdateServiceError.badUrl }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            
            return try decodePatchVersionJson(from: data)
        }
        catch {
            throw error
        }
    }
    
    private static func decodePatchVersionJson(from data: Data) throws -> String {
        do {
            let decodable = try JSONDecoder().decode([String].self, from: data)
            
            if decodable.isEmpty {
                throw UpdateServiceError.noData
            }
            else {
                return decodable[0]
            }
        }
        catch {
            throw UpdateServiceError.decodingFail
        }
    }
}
