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
    
    func getIcons(_ caller: ChampionList, for champions: [Champion])
}

class ChampionList {
    var delegate: ChampionListDelegate?
    private var championsDataSubject = PassthroughSubject<[Champion], Error>()
    private var championIconsSubject = PassthroughSubject<[Data], Error>()
    var championsDataPublisher: AnyPublisher<[Champion], Error>
    var championIconsPublisher: AnyPublisher<[Data], Error>
    
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
    
    func sendIcons(data: Result<[Data], Error>) {
        switch data {
        case .success(let data):
            championIconsSubject.send(data)
            championIconsSubject.send(completion: .finished)
        case .failure(let error):
            championIconsSubject.send(completion: .failure(error))
        }
    }
}
