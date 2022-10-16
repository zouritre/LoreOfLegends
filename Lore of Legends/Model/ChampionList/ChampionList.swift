//
//  ChampionList.swift
//  LoreOL
//
//  Created by Bertrand Dalleau on 13/10/2022.
//

import Foundation

protocol ChampionListDelegate {
    func getChampions()
}

class ChampionList {
    var delegate: ChampionListDelegate?
    
    func sendChampionsList(champions: [Champion]) {
        let notifName = Notification.Name("championsList")
        let notif = Notification(name: notifName, userInfo: ["list": champions])
        
        NotificationCenter.default.post(notif)
    }
}
