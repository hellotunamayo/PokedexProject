//
//  SearchViewModel.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/28/24.
//

import SwiftUI

@Observable
final class LocaledSearchViewModel: Sendable {
    nonisolated(unsafe) private(set) var searchResult: [PokemonListObject] = []
    nonisolated(unsafe) private(set) var searchResultViewCell: [SearchViewCell] = []
    nonisolated(unsafe) private(set) var pokemonLocaleList: [PokemonLocalNameModel] = []
    
    init() {
        Task {
            await getFullLocaleList()
        }
    }
    
    @MainActor
    func search(searchKeyword: String, pokemonList: [PokemonListObject]) {
        var viewCells: [SearchViewCell] = []
        searchResult = []
        searchResultViewCell = []
        
        pokemonLocaleList.forEach { localedList in
            if localedList.name.kr.localizedStandardContains(searchKeyword) ||
               localedList.name.en.localizedStandardContains(searchKeyword) ||
               localedList.name.jp.localizedStandardContains(searchKeyword) ||
                localedList.id == Int(searchKeyword) {
                searchResult.append(PokemonListObject(name: localedList.name.en, url: "https://pokeapi.co/api/v2/pokemon/\(localedList.id)/"))
            }
        }
        
        searchResult.forEach { listObject in
            viewCells.append(SearchViewCell(endpoint: listObject.url))
        }
        
        searchResultViewCell = viewCells
    }
    
    func getFullLocaleList() async -> () {
        let url = Bundle.main.url(forResource: "pokemonLocalNames", withExtension: "json")!
        let request = URLRequest(url: url)
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let jsonData = try JSONDecoder().decode([PokemonLocalNameModel].self, from: data)
            self.pokemonLocaleList = jsonData
        } catch {
            print(error)
        }
    }
    
    @MainActor
    func emptyResult() {
        searchResult = []
        searchResultViewCell = []
    }
}
