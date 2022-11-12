//
//  ChampionListError.swift
//  LoreOL
//
//  Created by Bertrand Dalleau on 13/10/2022.
//

import Foundation

extension RiotCdnApiError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .DecodingFail:
            return NSLocalizedString("Data decoding failed.", comment: "Json decoding failed on championFullData.json data")
        case .badUrl:
            return "Champ list bad url"
        case .GetJsonFailed:
            return "Champ list failed json"
        case .noDataForLanguage:
            return "No data for language"
        case .CastingFailed:
            return "Casting failed"
        case .NoDataFetchedForRow:
            return "Couldn't retrieve saved data for a champion"
        }
    }
}

enum RiotCdnApiError: Error {
    case DecodingFail
    case badUrl
    case GetJsonFailed
    case noDataForLanguage
    case CastingFailed
    case NoDataFetchedForRow
}
