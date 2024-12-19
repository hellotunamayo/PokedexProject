//
//  EntryViewModel.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/18/24.
//

import Foundation
import Observation

@Observable
final class EntryViewModel {
    private let service: any EntryUseCase
    private(set) var pokeList: [PokemonListObject] = []
    private(set) var initialFetchedResult: [PokemonListObject] = []
    
    private let limit: Int
    private let offset: Int
    
    init(
        limit: Int,
        offset: Int,
        service: any EntryUseCase
    ) {
        self.limit = limit
        self.offset = offset
        self.service = service
    }
    
    @MainActor
    func fetch() async {
        let result = await service.fetch(with: limit, offset: offset)
        
        pokeList = result
        initialFetchedResult = result
    }
    
    func search(searchKeyword: String) -> [PokemonListObject] {
        return initialFetchedResult.filter{ $0.name.contains(searchKeyword.lowercased()) }
    }
    
}
