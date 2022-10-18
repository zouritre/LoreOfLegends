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
    
    func sendChampionsList(champions: [Champion]?, error: Error?) {
        let notifName = Notification.Name("championsData")
        
        if let champions {
            createNotification(name: notifName, userInfo: ["list": champions])
        }
        if let error {
            createNotification(name: notifName, userInfo: ["error": error])
        }
    }
    
    private func createNotification(name: Notification.Name, userInfo: [String:Any]) {
        let notif = Notification(name: name, userInfo: userInfo)
        
        NotificationCenter.default.post(notif)
    }
}
