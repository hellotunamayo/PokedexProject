//
//  ContentView.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/18/24.
//

import SwiftUI

struct EntryView: View {
    
    @State private var searchKeyword: String = ""
    @State private var searchedValue: [PokemonListObject]?
    var viewModel: EntryViewModel = EntryViewModel(limit: 649)
    
    var body: some View {
        NavigationStack{
            ScrollView {
                ForEach(viewModel.pokeList, id: \.self) { pokemon in
                    NavigationLink {
                        PokemonDetailView(pokeData: pokemon, endpoint: pokemon.url)
                    } label: {
                        HStack {
                            Text(String(pokemon.name).capitalized)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(Color.gray)
                        }
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                    }
                    .frame(minWidth: 300, maxWidth: .infinity, idealHeight: 40)
                    .background(Color.white)
                }
            }
            .navigationTitle("Pokemon List")
            .navigationBarTitleDisplayMode(.inline)
        }
        .searchable(text: $searchKeyword, placement: .automatic) {
            NavigationStack {
                ForEach(searchedValue ?? [], id: \.self) { value in
                    NavigationLink("\(value.name)") {
                        PokemonDetailView(pokeData: value, endpoint: value.url)
                    }
                }
            }
        }
        .onSubmit(of: .search) {
            Task {
                searchedValue = try await viewModel.search(searchKeyword: searchKeyword)
            }
        }
        .onAppear {
            Task{
                try await viewModel.initialFetch()
            }
        }
    }
    
}

#Preview {
    EntryView(viewModel: EntryViewModel(limit: 10))
}
