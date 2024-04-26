//
//  ContentView.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/18/24.
//

import SwiftUI

struct EntryView: View {
    
    @State private var searchKeyword: String = ""
    @State private var searchedPokemon: [PokemonListObject]?
    @State private var isSearching: Bool = false
    
    var viewModel: EntryViewModel
    let startFrom: Int
    
    let gridItems: [GridItem] = [GridItem(.adaptive(minimum: 100, maximum: .infinity))]
    
    var body: some View {
        VStack {
            VStack {
                if isSearching {
                    Button(action: {
                        isSearching = false
                    }, label: {
                        Text("Dismiss Search")
                    })
                    
                    List(searchedPokemon ?? [], id: \.self) { result in
                        LazyVStack {
                            NavigationLink(result.name) {
                                PokemonDetailView(pokeData: result, endpoint: result.url)
                            }
                        }
                    }
                } else {
                    //MARK: 비검색중 화면
                    ScrollView {
                        ForEach(0..<viewModel.pokeList.count, id: \.self) { i in
                            LazyVStack {
                                NavigationLink {
                                    PokemonDetailView(pokeData: viewModel.pokeList[i], endpoint: viewModel.pokeList[i].url)
                                } label: {
                                    EntryViewCell(index: i + startFrom, pokemonName: viewModel.pokeList[i].name)
                                        .frame(height: 140)
                                }
                                .backgroundStyle(Color("backgroundColor"))
                            }
                            .padding(.vertical, -4)
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            HStack {
                                Image("pokedexIcon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 20, alignment: .center)
                                
                                Text("\(startFrom + 1) - \(startFrom + viewModel.pokeList.count)")
                                    .font(Font.custom("Silkscreen-Regular", size: 18))
                                    
                            }
                        }
                    }
                }
            }
//            .searchable(text: $searchKeyword, prompt: "Search Pokémon")
//            .onSubmit(of: .search) {
//                getSearchResult()
//                isSearching = true
//            }
        }
        .task {
            do {
                let _ = try await viewModel.initialFetch()
            } catch {
                print("WTF")
            }
        }
    }
    
}

//MARK: 함수
extension EntryView {
    func getSearchResult() {
        if !searchKeyword.isEmpty {
            var result: [PokemonListObject] = []
            var _ = viewModel.pokeList.filter {
                if $0.name.lowercased().localizedStandardContains(searchKeyword) { //true면
                    result.append($0)
                    return true
                } else {
                    return false
                }
            }
            searchedPokemon = result
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
    EntryView(viewModel: EntryViewModel(limit: 30, offset: 0), startFrom: 0)
}
