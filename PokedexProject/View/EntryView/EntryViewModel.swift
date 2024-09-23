//
//  EntryViewModel.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/18/24.
//

import Foundation
import Observation

@Observable
final class EntryViewModel: Sendable {
    private let service: any EntryUseCase
    @MainActor private(set) var pokeList: [PokemonListObject] = []
    @MainActor private(set) var initialFetchedResult: [PokemonListObject] = []
    
    private let urlString: String
    private let limit: Int
    private let offset: Int
    
    init(
        urlString: String = "",
        limit: Int,
        offset: Int,
        service: any EntryUseCase
    ) {
        self.limit = limit
        self.offset = offset
        self.urlString = "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)"
        self.service = service
    }
    
    @MainActor
    func fetch() async {
        let result = await service.fetch(with: urlString)
        
        pokeList = result
        initialFetchedResult = result
    }
    
    @MainActor
    func search(searchKeyword: String) -> [PokemonListObject] {
        return initialFetchedResult.filter{ $0.name.contains(searchKeyword.lowercased()) }
    }
    
}
