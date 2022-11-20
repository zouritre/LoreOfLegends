//
//  RiotCdnApiError.swift
//  LoreOL
//
//  Created by Bertrand Dalleau on 13/10/2022.
//

import Foundation

extension RiotCdnApiError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .DecodingFail:
            return NSLocalizedString("Data decoding failed.", comment: "Server response could not be decoded")
        case .badUrl:
            return NSLocalizedString("Invalid URL for API access", comment: "The URL generated is not valid")
        }
    }
}

enum RiotCdnApiError: Error {
    case DecodingFail
    case badUrl
}
