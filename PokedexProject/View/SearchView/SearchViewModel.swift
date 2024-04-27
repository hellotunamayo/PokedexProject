//
//  SearchViewModel.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/28/24.
//

import SwiftUI

@Observable
class SearchViewModel {
    private(set) var searchResult: [PokemonListObject] = []
    private(set) var searchResultViewCell: [SearchViewCell] = []
    
    init() {
        emptyResult()
    }
    
    func search(searchKeyword: String, pokemonList: [PokemonListObject]) {
        var viewCells: [SearchViewCell] = []
        searchResult = []
        searchResultViewCell = []
        
        searchResult = pokemonList.filter{ $0.name.lowercased().localizedStandardContains(searchKeyword) }
        searchResult.forEach { listObject in
            viewCells.append(SearchViewCell(endpoint: listObject.url))
        }
        searchResultViewCell = viewCells
    }
    
    func emptyResult() {
        searchResult = []
        searchResultViewCell = []
    }
}
