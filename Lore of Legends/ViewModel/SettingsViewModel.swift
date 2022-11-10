//
//  SettingsViewModel.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 10/11/2022.
//

import Foundation
import Combine

class SettingsViewModel {
    var languages: [String]?
    var settings = Settings()
    var adapter: SettingsDelegate = SettingsAdapter()
    var languagesSubscriber: AnyCancellable?
    
    init(adapter: SettingsDelegate? = nil) {
        if let adapter {
            self.adapter = adapter
            self.settings.delegate = adapter
        }
        else {
            self.settings.delegate = self.adapter
        }
        
        languagesSubscriber = settings.languagesPublisher.sink(receiveCompletion: { _ in }, receiveValue: { [unowned self] langs in
            print("here")
            languages = langs
        })
    }
    
    func getLanguages() {
        settings.delegate?.getLanguages(caller: settings)
    }
}
