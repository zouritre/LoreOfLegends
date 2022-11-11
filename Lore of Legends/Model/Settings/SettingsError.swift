//
//  SettingsError.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 10/11/2022.
//

import Foundation

extension SettingsError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .NilDelegateForApi:
            return NSLocalizedString("Couldn't communicate with API.", comment: "RiotCdnApi class delegate is nil")
        case .badUrl:
            return NSLocalizedString("Couldn't reach API", comment: "Bad URL for request")
        }
    }
}


/// Informations about errors occuring with Settings functionnality
enum SettingsError: Error {
    case NilDelegateForApi
    case badUrl
}
