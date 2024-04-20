//
//  ContentView.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/18/24.
//

import SwiftUI
import ColorKit

struct EntryView: View {
    
    @State private var searchKeyword: String = ""
    @State private var searchedValue: [PokemonListObject]?
    var viewModel: EntryViewModel = EntryViewModel(limit: 649)
    
    var body: some View {
        NavigationStack{
            ScrollView {
                ForEach(0..<viewModel.pokeList.count, id: \.self) { i in
                    LazyVStack {
                        NavigationLink {
                            PokemonDetailView(pokeData: viewModel.pokeList[i], endpoint: viewModel.pokeList[i].url)
                        } label: {
                            EntryViewCell(index: i, pokemonName: viewModel.pokeList[i].name)
                                .frame(height: 140)
                        }
                        .backgroundStyle(Color("backgroundColor"))
                    }
                    .padding(.vertical, -2)
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
    
    func getPokemonPortrait(urlString url: String) async throws -> URL {
        enum PortraitFetchError: String, Error {
            case urlNotFound = "URL not found"
            case failedToDecodeJSON = "Failed to decode JSON"
            case cantCreateURLObject = "Could not create URL object"
            case unknownError = "Unknown error occurred"
        }
        guard let returnURL: URL = URL(string: url) else {
            print(PortraitFetchError.urlNotFound.rawValue)
            throw PortraitFetchError.urlNotFound
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: returnURL)
            guard let jsonData = try? JSONDecoder().decode(PokemonDetailData.self, from: data) else {
                print(PortraitFetchError.failedToDecodeJSON.rawValue)
                throw PortraitFetchError.failedToDecodeJSON
            }
            let portraitURLString: String = jsonData.sprites.frontDefault
            guard let portraitURL = URL(string: portraitURLString) else {
                print(PortraitFetchError.cantCreateURLObject.rawValue)
                throw PortraitFetchError.cantCreateURLObject
            }
            return portraitURL
        } catch {
            print(PortraitFetchError.unknownError.rawValue)
            throw PortraitFetchError.unknownError
        }
    }
    
}

#Preview {
    EntryView(viewModel: EntryViewModel(limit: 10))
}
