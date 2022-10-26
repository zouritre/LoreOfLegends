//
//  UpdateServiceError.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 26/10/2022.
//

import Foundation

extension UpdateServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .badUrl:
            return "Update service bad url"
        case .decodingFail:
            return "Update service decoding fail"
        case .noData:
            return "Update service no data"
        }
    }
}

enum UpdateServiceError: Error {
    case badUrl
    case decodingFail
    case noData
}
