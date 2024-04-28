//
//  EntryUseCase.swift
//  PokedexProject
//
//  Created by jinwoong Kim on 4/28/24.
//

import Foundation

protocol EntryUseCase {
    func fetch(with urlString: String) async -> [PokemonListObject]
}
