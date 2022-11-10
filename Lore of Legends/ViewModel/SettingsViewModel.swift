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
    /// Use-case object
    var settings = Settings()
    /// Object that manages Api requests
    var adapter: SettingsDelegate = SettingsAdapter()
    /// Receives notifcation from the adapter
    var languagesSubscriber: AnyCancellable?
    
    init(adapter: SettingsDelegate? = nil) {
        if let adapter {
            // Set a custom adapter
            self.adapter = adapter
            self.settings.delegate = adapter
        }
        else {
            // Use the default adapter
            self.settings.delegate = self.adapter
        }
        
        // Set up the subscriber
        languagesSubscriber = settings.languagesPublisher.sink(receiveCompletion: { _ in }, receiveValue: { [unowned self] langs in
            languages = langs
        })
    }
    
    /// Request the list of languages supported by Riot CDN
    func getLanguages() {
        settings.delegate?.getLanguages(caller: settings)
    }
}
