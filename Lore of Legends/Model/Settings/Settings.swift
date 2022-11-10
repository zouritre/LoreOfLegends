//
//  Settings.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 10/11/2022.
//

import Foundation
import Combine

protocol SettingsDelegate: AnyObject {
    func getLanguages(caller: Settings)
}

class Settings {
    weak var delegate: SettingsDelegate?
    var languagesPublisher = PassthroughSubject<[String], Error>()
}
