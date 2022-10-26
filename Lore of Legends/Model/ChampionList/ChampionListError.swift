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
            return ""
        case .GetJsonFailed:
            return ""
        }
    }
}

enum ChampionListError: Error {
    case DecodingFail
    case badUrl
    case GetJsonFailed
}
