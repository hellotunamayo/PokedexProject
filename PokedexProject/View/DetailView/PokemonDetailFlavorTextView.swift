//
//  PokemonDetailFlavorTextView.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/29/24.
//

import SwiftUI

struct PokemonDetailFlavorTextView: View {
    
    @State private var selectedLocale: Locale?
    
    let flavorTextData: [FlavorText]
    let pokemonName: String
    let pokemonPortraitURLString: String
    let pokemonTypeData: (typeIconName: String, typeColor: UIColor)
    let gridItem: [GridItem] = [
        GridItem(.flexible(minimum: 30, maximum: 300)),
        GridItem(.flexible(minimum: 30, maximum: 300))
    ]
    
    var pokemonportraitURL: URL {
        URL(string: pokemonPortraitURLString) ?? Bundle.main.url(forResource: "pokedexIcon", withExtension: "png")!
    }
    
    var body: some View {
        HStack {
            Circle()
                .foregroundStyle(Color(pokemonTypeData.typeColor).opacity(0.2))
                .frame(width: 30, height: 30, alignment: .center)
                .overlay {
                    AsyncImage(url: pokemonportraitURL) { result in
                        result.image?
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                    }
                }
                .clipShape(Circle())
            
            Circle()
                .foregroundStyle(Color(pokemonTypeData.typeColor))
                .frame(width: 30, height: 30, alignment: .center)
                .overlay {
                    Image(pokemonTypeData.typeIconName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(Color.white)
                        .frame(width: 15, height: 15, alignment: .center)
                }
            
            Text(pokemonName.capitalized)
                .font(.title)
                .fontWeight(.black)
                .lineLimit(1)
                .minimumScaleFactor(0.2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 2)
        }
        .padding(.horizontal)
        .frame(height: 60)
        
        ScrollView {
            LazyVGrid(columns: gridItem, content: {
                Button(action: {
                    selectedLocale = .en
                }, label: {
                    Text("en")
                })
                .sheet(item: $selectedLocale) { view in
                    PokemonFlavorTextSheetView(locale: $selectedLocale, flavorText: flavorTextData)
                }
                
                Button(action: {
                    selectedLocale = .jp
                }, label: {
                    Text("jp")
                })
                .sheet(item: $selectedLocale) { view in
                    PokemonFlavorTextSheetView(locale: $selectedLocale, flavorText: flavorTextData)
                }
                
                Button(action: {
                    selectedLocale = .ko
                }, label: {
                    Text("ko")
                })
                .sheet(item: $selectedLocale) { view in
                    PokemonFlavorTextSheetView(locale: $selectedLocale, flavorText: flavorTextData)
                }
            })
        }
    }
    
}

#Preview {
    PokemonDetailFlavorTextView(flavorTextData: [FlavorText(flavorText: "test string", language: FlavorTextLanguage(name: "en", url: ""), version: FlavorTextVersion(name: "red", url: ""))],
                                pokemonName: "SampleMon",
                                pokemonPortraitURLString: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/865.png",
                                pokemonTypeData: ("normal", UIColor.systemMint))
}
