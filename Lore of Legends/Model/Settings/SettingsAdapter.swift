//
//  SettingsAdapter.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 10/11/2022.
//

import Foundation

extension SettingsAdapter: SettingsDelegate {
    func getLanguages(caller: Settings) {
        print("there")
        caller.languagesPublisher.send(["Hello"])
    }
}

class SettingsAdapter {
//    var api: 
}
