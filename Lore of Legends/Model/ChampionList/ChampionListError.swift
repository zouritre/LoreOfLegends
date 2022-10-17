//
//  ChampionListError.swift
//  LoreOL
//
//  Created by Bertrand Dalleau on 13/10/2022.
//

import Foundation

enum ChampionListError: String, Error {
    case NotificationDataIsEmpty = "ChampionListError.NotificationDataIsEmpty"
    case NotificationNoData = "ChampionListError.NotificationNoData"
    case BundleReadFail = "ChampionListError.BundleReadFail"
    case DecodingFail = "ChampionListError.DecodingFail"
}
