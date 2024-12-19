//
//  PokemonDetailUseCase.swift
//  PokedexProject
//
//  Created by jinwoong Kim on 4/28/24.
//

import Foundation

protocol PokemonDetailUseCase: Sendable {
    func fetch(with pokemonListObject: PokemonListObject) async -> PokemonDetailData?
    func fetch_Spicies(with pokemonDetailData: PokemonDetailData) async -> PokemonSpeciesData?
}
