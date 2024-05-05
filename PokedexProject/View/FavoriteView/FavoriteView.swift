//
//  FavoriteView.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 5/4/24.
//

import SwiftUI
import SwiftData

struct FavoriteView: View {
    @Query var favoritedPokemon: [FavoriteModel]
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationStack {
            HStack {
                Image("pokedexIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24, alignment: .center)
                
                Text("Favorite")
                    .font(Font.custom("Silkscreen-Regular", size: 24))
            }
            
            if favoritedPokemon.isEmpty {
                EmptyFavoriteView()
                    .frame(maxHeight: .infinity)
            } else {
                ScrollView {
                    ForEach(favoritedPokemon) { pokemon in
                        LazyVStack {
                            NavigationLink {
                                PokemonDetailView(pokeData: pokemon.pokemonListObject, endpoint: "https://pokeapi.co/api/v2/pokemon/\(pokemon.pokemonIndex)/")
                            } label: {
                                EntryViewCell(index: pokemon.pokemonIndex - 1, pokemonName: pokemon.pokemonName)
                                    .frame(height: 140)
                            }
                            .backgroundStyle(Color("backgroundColor"))
                            .contextMenu {
                                Button("Remove from favorite", 
                                       systemImage: "trash",
                                       role: .destructive) {
                                    do {
                                        try removeFavorite(pokemonIdx: pokemon.pokemonIndex)
                                    } catch {
                                        print(error)
                                    }
                                }
                            }
                        }
                        .padding(.vertical, -4)
                    }
                }
            }
        }
    }
}

extension FavoriteView {
    func removeFavorite(pokemonIdx: Int) throws {
        try modelContext.delete(model: FavoriteModel.self,
                                where: #Predicate{ $0.pokemonIndex == pokemonIdx })
    }
}

struct EmptyFavoriteView: View {
    var body: some View {
        VStack{
            Image("emptyViewCharacterImage")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 190, maxHeight: 190, alignment: .center)
            Text("You haven't add\nany Pokémon!")
                .multilineTextAlignment(.center)
                .fontWeight(.bold)
                .font(.title)
                .padding(.top, -10)
        }
    }
}

#Preview {
    FavoriteView()
}
