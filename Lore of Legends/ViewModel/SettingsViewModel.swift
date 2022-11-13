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
    
    var settings = Settings()
    var languagesSubscriber: AnyCancellable?
    
    init(riotCdnApi: RiotCdnApiDelegate? = nil) {
        if let riotCdnApi {
            self.settings = Settings(riotCdnApi: riotCdnApi)
        }
        
        languagesSubscriber = settings.languagesPublisher.sink { [unowned self] languages in
            self.languages.value = languages
        }
    }
    
    func getSupportedLanguages() {
        settings.getSupportedLanguages()
    }
}
