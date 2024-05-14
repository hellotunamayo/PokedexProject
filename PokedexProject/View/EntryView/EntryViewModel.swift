//
//  EntryViewModel.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/18/24.
//

import Foundation
import Observation

@Observable
class EntryViewModel {
    private let service: any EntryUseCase
    private(set) var pokeList: [PokemonListObject] = []
    private(set) var initialFetchedResult: [PokemonListObject] = []
    
    var urlString: String
    var limit: Int
    var offset: Int
    
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
    
    func fetch() async {
        let result = await service.fetch(with: urlString)
        
        pokeList = result
        initialFetchedResult = result
    }
    
    func search(searchKeyword: String) -> [PokemonListObject] {
        return initialFetchedResult.filter{ $0.name.contains(searchKeyword.lowercased()) }
    }
    
}
