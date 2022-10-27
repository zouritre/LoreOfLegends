//
//  ChampionListError.swift
//  LoreOL
//
//  Created by Bertrand Dalleau on 13/10/2022.
//

import Foundation

extension ChampionListError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .DecodingFail:
            return NSLocalizedString("ChampionListError.DecodingFail", comment: "Json decoding failed on champion json data")
        case .badUrl:
            return "Champ list bad url"
        case .GetJsonFailed:
            return "Champ list failed json"
        case .noDataForLanguage:
            return "No data for language"
        }
    }
}

enum ChampionListError: Error {
    case DecodingFail
    case badUrl
    case GetJsonFailed
    case noDataForLanguage
}
