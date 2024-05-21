//
//  SearchView.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/27/24.
//

import SwiftUI

struct SearchView: View {
    
    @State private var searchKeyword: String = ""
    @FocusState private var searchFocused
    let localedSearchViewModel: LocaledSearchViewModel = LocaledSearchViewModel()
//    let searchViewModel: SearchViewModel = SearchViewModel()
    let viewModel: EntryViewModel
    
    var body: some View {
        NavigationStack {
            if localedSearchViewModel.searchResult.isEmpty {
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
                VStack {
                    Button(action: {
                        localedSearchViewModel.emptyResult()
                    }, label: {
                        Label("Clear result", systemImage: "xmark")
                    })
                    .tint(Color(UIColor.systemGray))
                    .buttonStyle(BorderedButtonStyle())
                    .clipShape(Capsule())
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 5, leading: 16, bottom: 5, trailing: 16))
                
                ScrollView {
                    ForEach(Array(localedSearchViewModel.searchResultViewCell.enumerated()), id: \.offset) { index, element in
                        NavigationLink {
                            if let searchResult = localedSearchViewModel.searchResult[safe: index] {
                                PokemonDetailView(pokeData: searchResult, endpoint: searchResult.url)
                            }
                        } label: {
                            if let searchResultViewCell = localedSearchViewModel.searchResultViewCell[safe: index] {
                                searchResultViewCell
                                    .frame(height: 140)
                                    .padding(.vertical, -10)
                            }
                        }
                    }
                }
            }
        }
        .searchable(text: $searchKeyword, prompt: Text("Pokémon name or index number"))
        .autocorrectionDisabled()
        .onSubmit(of: .search) {
            localedSearchViewModel.search(searchKeyword: "", pokemonList: viewModel.pokeList)
            if !searchKeyword.isEmpty {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    localedSearchViewModel.search(searchKeyword: searchKeyword, pokemonList: viewModel.pokeList)
                }
            } else {
                localedSearchViewModel.emptyResult()
            }
        }
    }
    
}

#Preview {
    SearchView(viewModel: EntryViewModel(limit: 1100, offset: 0, service: PokemonAPIService()))
}
