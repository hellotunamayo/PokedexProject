//
//  FavoriteModel.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 5/4/24.
//

import Foundation
import SwiftData

@Model
final class FavoriteModel: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var pokemonName: String
    var pokemonIndex: Int
    var pokemonFrontPortraitURLString: String?
    var pokemonType: PokemonType?
    var pokemonListObject: PokemonListObject
    
    init(pokemonName: String, 
         pokemonIndex: Int,
         pokemonListObject: PokemonListObject) {
        self.pokemonName = pokemonName
        self.pokemonIndex = pokemonIndex
        self.pokemonListObject = pokemonListObject
    }
}
