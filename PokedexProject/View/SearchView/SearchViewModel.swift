//
//  SearchViewModel.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/28/24.
//

import SwiftUI

@Observable
final class LocaledSearchViewModel {
    private(set) var searchResult: [PokemonListObject] = []
    private(set) var searchResultViewCell: [SearchViewCell] = []
    private(set) var pokemonLocaleList: [PokemonLocalNameModel] = []
    
    init() {
        getFullLocaleList()
    }
    
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
    
    func getFullLocaleList() {
        let url = Bundle.main.url(forResource: "pokemonLocalNames", withExtension: "json")!
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            do {
                guard let data = data else {
                    print("data not found")
                    return
                }
                let jsonData = try JSONDecoder().decode([PokemonLocalNameModel].self, from: data)
                self?.pokemonLocaleList = jsonData
//                print(self?.pokemonLocaleList)
            } catch {
                print(error)
            }
            
        }.resume()
    }
    
    func emptyResult() {
        searchResult = []
        searchResultViewCell = []
    }
}
//
//@Observable
//class SearchViewModel {
//    private(set) var searchResult: [PokemonListObject] = []
//    private(set) var searchResultViewCell: [SearchViewCell] = []
//    
//    init() {
//        emptyResult()
//    }
//    
//    func search(searchKeyword: String, pokemonList: [PokemonListObject]) {
//        var viewCells: [SearchViewCell] = []
//        searchResult = []
//        searchResultViewCell = []
//        
//        searchResult = pokemonList.filter{ $0.name.lowercased().localizedStandardContains(searchKeyword) }
//        searchResult.forEach { listObject in
//            viewCells.append(SearchViewCell(endpoint: listObject.url))
//        }
//        searchResultViewCell = viewCells
//    }
//    
//    func emptyResult() {
//        searchResult = []
//        searchResultViewCell = []
//    }
//}
