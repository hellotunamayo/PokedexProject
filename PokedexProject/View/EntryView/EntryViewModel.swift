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
    private let apiUseCase: some EntryUseCase = PokemonAPIService()
    private(set) var pokeList: [PokemonListObject] = []
    private(set) var initialFetchedResult: [PokemonListObject] = []
    
    var urlString: String
    var limit: Int
    var offset: Int
    
    init(urlString: String = "", limit: Int, offset: Int) {
        self.limit = limit
        self.offset = offset
        self.urlString = "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)"
        
        Task {
            await initialFetch()
        }
    }
    
    @MainActor func initialFetch() async {
        let result = await apiUseCase.fetch(with: urlString)
        
        pokeList = result
        initialFetchedResult = result
    }
    
    func search(searchKeyword: String) -> [PokemonListObject] {
        return initialFetchedResult.filter{ $0.name.contains(searchKeyword.lowercased()) }
    }
    
}
