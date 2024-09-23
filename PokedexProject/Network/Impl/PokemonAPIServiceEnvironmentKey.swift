//
//  PokemonAPIServiceEnvironmentKey.swift
//  PokedexProject
//
//  Created by jinwoong Kim on 5/15/24.
//

import SwiftUI

struct PokemonAPIServiceEnvironmentKey: @preconcurrency EnvironmentKey, Sendable {
    @MainActor static let defaultValue: PokemonAPIService = .init()
}

extension EnvironmentValues {
    var pokemonAPIService: PokemonAPIService {
        get { self[PokemonAPIServiceEnvironmentKey.self] }
        set { self[PokemonAPIServiceEnvironmentKey.self] = newValue }
    }
}
