//
//  CoreDataApiError.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 13/11/2022.
//

import Foundation

extension CoreDataApiError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .castingFailed:
            return NSLocalizedString("Couldn't retrieve champions from database", comment: "Failed casting fetched data")
        }
    }
}
enum CoreDataApiError: Error {
    case castingFailed
}
