//
//  APIModel.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/18/24.
//

import Foundation

struct PokemonList: Codable {
    var count: Int
    var next: String
    var previous: String?
    var defaultPrevious: String { previous ?? "" }
    var results: [PokemonListObject]
}

struct PokemonListObject: Codable, Hashable {
    var name: String
    var url: String
}

struct PokemonDetailData: Codable {
    let id: Int
    let height: Int
    let name: String
//    let names: [PokemonNameData] // pokemon-spicies 로 받아와야 함... 나중에...
    let cries: PokemonCries
    let sprites: PokemonSprite
    let stats: [PokemonStat]
    let types: [PokemonTypeData]
}

//MARK: pokemon-spicies 로 받아와야 함...
//struct PokemonNameData: Codable {
//    let language: PokemonNameLanguage
//    let name: String
//}
//
//struct PokemonNameLanguage: Codable {
//    let name: String
//    let url: String
//}

struct PokemonTypeData: Codable {
    let slot: Int
    let type: PokemonType
}

struct PokemonType: Codable {
    let name: String
    let url: String
}

struct PokemonStat: Codable {
    let baseStat: Int
    let effort: Int
    let stat: PokemonStatType
    
    enum CodingKeys: String, CodingKey {
        case effort, stat
        case baseStat = "base_stat"
    }
}

struct PokemonStatType: Codable {
    let name: String
    let url: String
}

struct PokemonCries: Codable {
    let latest: String
    let legacy: String
}

struct PokemonSprite: Codable {
    let frontDefault: String
    let backDefault: String
    let frontShiny: String
    let backShiny: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case backDefault = "back_default"
        case frontShiny = "front_shiny"
        case backShiny = "back_shiny"
    }
}
