//
//  NetworkService.swift
//  Lore-of-Legends
//
//  Created by Bertrand Dalleau on 23/10/2022.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()
    
    var session = URLSession(configuration: .default)
    
    private init() {}
    
    func getDataOnly(for url: URL, completion: @escaping (Data?, Error?) -> Void) {
        session.dataTask(with: url, completionHandler: { data, _, error in
            completion(data, error)
        })
    }
}
