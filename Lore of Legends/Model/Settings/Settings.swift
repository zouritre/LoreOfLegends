//
//  Settings.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 10/11/2022.
//

import Foundation
import Combine

protocol SettingsDelegate: AnyObject {
    /// Request all languages supported by Riot CDN API
    /// - Parameter caller: Object wich called this method
    func getLanguages(caller: Settings)
}

/// Main use-case for Settings functionnality
class Settings {
    /// Object responsible for handling language list requests
    weak var delegate: SettingsDelegate?
    /// Publisher that send result for languages request
    var languagesPublisher = PassthroughSubject<[Locale], Error>()
}
