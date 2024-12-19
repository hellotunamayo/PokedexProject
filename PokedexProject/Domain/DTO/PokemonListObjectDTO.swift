//
//  PokemonListObjectDTO.swift
//  PokedexProject
//
//  Created by 홍진표 on 12/19/24.
//

import Foundation

struct PokemonListObjectDTO: Encodable {
    let limit: Int
    let offset: Int
    
    init(limit: Int, offset: Int) {
        self.limit = limit
        self.offset = offset
    }
}
