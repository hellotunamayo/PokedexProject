//
//  PokemonLocalNameModel.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/28/24.
//

import Foundation

struct PokemonLocalNameModel: Codable, Identifiable {
    let id: Int
    let name: PokemonNameByLocale
}

struct PokemonNameByLocale: Codable {
    let en: String
    let kr: String
    let jp: String
}
