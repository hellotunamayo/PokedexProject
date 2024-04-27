//
//  SearchView.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/27/24.
//

import SwiftUI

struct SearchView: View {
    
    @State private var searchKeyword: String = ""
    let searchViewModel: SearchViewModel = SearchViewModel()
    let viewModel: EntryViewModel = EntryViewModel(limit: 1100, offset: 0)
    
    var body: some View {
        NavigationStack {
            HStack {
                TextField("Search by Pokémon's name", text: $searchKeyword)
                    .textFieldStyle(.roundedBorder)
                    .onAppear {
                        UITextField.appearance().clearButtonMode = .always
                    }
                
                Button(action: {
                    searchViewModel.search(searchKeyword: "", pokemonList: viewModel.pokeList)
                    if !searchKeyword.isEmpty {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            searchViewModel.search(searchKeyword: searchKeyword, pokemonList: viewModel.pokeList)
                        }
                    } else {
                        searchViewModel.emptyResult()
                    }
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 6)
                            .foregroundStyle(Color(UIColor.systemBlue))
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(Color.white)
                    }
                    .frame(width: 60, height: 34, alignment: .center)
                })
            }
            .padding()
            
            if searchViewModel.searchResult.isEmpty {
                VStack {
                    Image("allpokemons")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(20)
                        .opacity(0.2)
                }
                .padding(.top, -40)
                .frame(maxHeight: .infinity)
            } else {
                ScrollView {
                    ForEach(Array(searchViewModel.searchResultViewCell.enumerated()), id: \.offset) { index, element in
                        NavigationLink {
                            if let searchResult = searchViewModel.searchResult[safe: index] {
                                PokemonDetailView(pokeData: searchResult, endpoint: searchResult.url)
                            }
                        } label: {
                            if let searchResultViewCell = searchViewModel.searchResultViewCell[safe: index] {
                                searchResultViewCell
                                    .frame(height: 140)
                                    .padding(.vertical, -10)
                            }
                        }
                    }
                }
            }
        }
    }
}

extension SearchView {
    
}

#Preview {
    SearchView()
}
