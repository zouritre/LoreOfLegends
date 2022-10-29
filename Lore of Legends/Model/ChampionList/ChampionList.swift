//
//  ChampionList.swift
//  LoreOL
//
//  Created by Bertrand Dalleau on 13/10/2022.
//

import Foundation
import Combine

/// Protocol to wich conform a class that's responsible for requesting full champion list and their icons
protocol ChampionListDelegate {
    /// Request the champion list and set their icons
    /// - Parameter caller: Model responsible for sending the API data to the view-model
    func getChampions(_ caller: ChampionList)
}

/// Model class that manages request for the champion list API
class ChampionList {
    /// Delegate that manage the API request
    var delegate: ChampionListDelegate?
    /// Publisher that send the API data back to the view-model subscribers
    var championsDataSubject = PassthroughSubject<[Champion], Error>()
    var totalChampionsCountPublisher = PassthroughSubject<Int, Never>()
    var downloadedChampionCounterPub = PassthroughSubject<Int, Never>()
}
