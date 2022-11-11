//
//  SettingsViewModel.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 10/11/2022.
//

import Foundation
import Combine

class SettingsViewModel {
    var languages = CurrentValueSubject<[Locale]?, Never>(nil)
    @Published var requestError: Error? = nil
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
        languagesSubscriber = settings.languagesPublisher.sink(receiveCompletion: { [unowned self] completion in
            switch completion {
            case .finished:
                return
            case .failure(let error):
                requestError = error
            }
        }, receiveValue: { [unowned self] langs in
            print("received languages")
            languages.value = langs
        })
    }
    
    /// Request the list of languages supported by Riot CDN
    func getLanguages() {
        settings.delegate?.getLanguages(caller: settings)
    }
}
