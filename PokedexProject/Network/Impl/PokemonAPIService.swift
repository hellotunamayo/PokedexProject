//
//  PokemonAPIService.swift
//  PokedexProject
//
//  Created by jinwoong Kim on 4/28/24.
//

import Foundation

final class PokemonAPIService: APIService {
    var session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
}
