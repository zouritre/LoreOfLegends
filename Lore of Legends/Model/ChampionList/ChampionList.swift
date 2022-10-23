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
    private var championsDataSubject = PassthroughSubject<[Champion], Error>()
    private var championIconsSubject = PassthroughSubject<[ChampionAsset], Never>()
    var championsDataPublisher: AnyPublisher<[Champion], Error>
    var championIconsPublisher: AnyPublisher<[ChampionAsset], Never>
    
    init() {
        championsDataPublisher = championsDataSubject.eraseToAnyPublisher()
        championIconsPublisher = championIconsSubject.eraseToAnyPublisher()
    }
    
    func sendChampionsData(result: Result<[Champion], Error>) {
        switch result {
        case .success(let data):
            championsDataSubject.send(data)
            championsDataSubject.send(completion: .finished)
        case .failure(let failure):
            championsDataSubject.send(completion: .failure(failure))
        }
    }
    
}
