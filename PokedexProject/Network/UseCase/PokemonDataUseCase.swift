//
//  PokemonDetailUseCase.swift
//  PokedexProject
//
//  Created by jinwoong Kim on 4/28/24.
//

import Foundation

protocol PokemonDetailUseCase: Sendable {
    func fetch(urlString: String) async -> PokemonDetailData?
    func fetchSpicies(urlString: String) async -> PokemonSpeciesData?
}
