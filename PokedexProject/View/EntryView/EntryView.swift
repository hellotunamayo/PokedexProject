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
                ForEach(0..<viewModel.pokeList.count, id: \.self) { i in
                    NavigationLink {
                        PokemonDetailView(pokeData: viewModel.pokeList[i], endpoint: viewModel.pokeList[i].url)
                    } label: {
                        LazyVStack {
                            HStack {
                                AsyncImage(url: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(i+1).png")) { phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 40, height: 40)
                                            .clipShape(.circle)
                                            .overlay{
                                                Circle()
                                                    .stroke(Color("pokeGray"))
                                                    .frame(width: 40, height: 40)
                                                    .foregroundStyle(Color.clear)
                                            }
                                    } else {
                                        ProgressView()
                                            .frame(width: 40, height: 40)
                                            .overlay{
                                                Circle()
                                                    .stroke(Color(UIColor(red: 200/255,
                                                                          green: 200/255,
                                                                          blue: 200/255,
                                                                          alpha: 1)))
                                                    .frame(width: 40, height: 40)
                                                    .foregroundStyle(Color.white)
                                            }
                                    }
                                    
                                }
                                ZStack {
                                    Capsule()
                                        .frame(width: 40, height: 40)
                                        .foregroundStyle(Color("pokeGray"))
                                    
                                    Text("\(i + 1)")
                                        .font(Font.caption)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(Color("lightGrayText"))
                                }
                                
                                Text(String(viewModel.pokeList[i].name).capitalized)
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color("textColor"))
                                    .offset(x: 5, y: 0)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(Color("textColor"))
                            }
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                        }
                    }
                    .frame(minWidth: 300, maxWidth: .infinity, idealHeight: 60)
                    .backgroundStyle(Color("backgroundColor"))
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
