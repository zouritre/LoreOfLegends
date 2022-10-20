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
    var championsDataPublisher = PassthroughSubject<[Champion], Error>()
    
    func sendChampionsData(result: Result<[Champion], Error>) {
        switch result {
        case .success(let data):
            championsDataPublisher.send(data)
            championsDataPublisher.send(completion: .finished)
        case .failure(let failure):
            championsDataPublisher.send(completion: .failure(failure))
        }
    }
}
