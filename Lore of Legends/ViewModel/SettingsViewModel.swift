//
//  SettingsViewModel.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 10/11/2022.
//

import Foundation
import Combine

class SettingsViewModel {
    @Published var languages: [Locale]?
    
    var settings = Settings()
    
    init(riotCdnApi: RiotCdnApiDelegate? = nil) {
        if let riotCdnApi {
            self.settings = Settings(riotCdnApi: riotCdnApi)
        }
        
        settings.languagesPublisher.assign(to: &$languages)
    }
    
    func getSupportedLanguages() {
        settings.getSupportedLanguages()
    }
}
