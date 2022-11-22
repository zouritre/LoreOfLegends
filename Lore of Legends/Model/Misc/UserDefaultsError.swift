//
//  UserDefaultsError.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 13/11/2022.
//

import Foundation

extension UserDefaultsError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .keyNotSet:
            return NSLocalizedString("Couldn't retrieve default configuration", comment: "Failed to read a configuration key")
        }
    }
}
enum UserDefaultsError: Error {
    case keyNotSet
}
