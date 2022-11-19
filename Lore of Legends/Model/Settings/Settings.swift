//
//  Settings.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 10/11/2022.
//

import Foundation
import Combine

class Settings {
    var riotCdnApi: RiotCdnApiDelegate? = RiotCdnApi.shared
    var languagesPublisher = PassthroughSubject<[Locale]?, Never>()
    
    init(riotCdnApi: RiotCdnApiDelegate? = nil) {
        if let riotCdnApi {
            self.riotCdnApi = riotCdnApi
        }
    }
    
    func getSupportedLanguages() async {
        let languages = try? await riotCdnApi?.getSupportedLanguages()
        
        languagesPublisher.send(languages)
    }
}
