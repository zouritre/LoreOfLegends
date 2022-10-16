//
//  ChampionListError.swift
//  LoreOL
//
//  Created by Bertrand Dalleau on 13/10/2022.
//

import Foundation

enum ChampionListError: String, Error {
    case NotificationDataIsEmpty = "Fail to retrieve champions data"
    case NotificationNoData = "No data received"
    case BundleReadFail = "Failed to read champions configuration files"
    case DecodingFail = "Failed to decode champion data"
}
