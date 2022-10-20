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
        case .NotificationNoData:
            return NSLocalizedString("ChampionListError.NotificationNoData", comment: "Notification userInfo is empty")
        case .BundleReadFail:
            return NSLocalizedString("ChampionListError.BundleReadFail", comment: "Json bundle for champions data couldn't be located")
        case .DecodingFail:
            return NSLocalizedString("ChampionListError.DecodingFail", comment: "Json decoding failed on champion json data")
        }
    }
}

enum ChampionListError: Error {
    case NotificationNoData
    case BundleReadFail
    case DecodingFail
}
