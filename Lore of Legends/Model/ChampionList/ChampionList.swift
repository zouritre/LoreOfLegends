//
//  ChampionList.swift
//  LoreOL
//
//  Created by Bertrand Dalleau on 13/10/2022.
//

import Foundation
import Combine

protocol ChampionListDelegate {
    func getChampions(_ caller: ChampionList)
}

class ChampionList {
    var delegate: ChampionListDelegate?
    var championsDataSubject = PassthroughSubject<[Champion], Error>()
}
