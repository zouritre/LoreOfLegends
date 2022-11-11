//
//  SettingsAdapter.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 10/11/2022.
//

import Foundation

extension SettingsAdapter: SettingsDelegate {
    func getLanguages(caller: Settings) {
        Task {
            do {
                // Request the list of supported languages
                let languages = try await delegate?.getSupportedLanguages()
                
                guard let languages else { throw SettingsError.NilDelegateForApi }
                
                caller.languagesPublisher.send(languages)
            }
            catch {
                caller.languagesPublisher.send(completion: .failure(error))
            }
        }
    }
}

class SettingsAdapter {
    /// Api to use for async request. Allows mocking
    private var api: RiotCdnApiDelegate? = RiotCdnApi()
    /// Same reference as the  api property
    weak var delegate: RiotCdnApiDelegate?
    
    init(api: RiotCdnApiDelegate? = nil) {
        if let api {
            // Set a custom api. Allows mocking
            self.api = api
            self.delegate = api
        }
        else {
            // Use the default api
            self.delegate = self.api
        }
    }
}
