//
//  PokemonMoveView.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/28/24.
//

import SwiftUI

struct PokemonMoveView: View {
    
    @State private var selectedMove: PokemonMoveDetail?
    let pokemonName: String
    let pokemonPortraitURLString: String
    let pokemonTypeData: (typeIconName: String, typeColor: UIColor)
    let pokemonMoveData: [PokemonMoveData]
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
        
        NavigationStack {
            ScrollView {
                Divider()
                    .padding(.horizontal)
                LazyVGrid(columns: gridItem) {
                    ForEach(0..<pokemonMoveData.count, id: \.self) { i in
                        ZStack {
                            Rectangle()
                                .foregroundStyle(Color(UIColor.pokeBrightGray))
                            
                            Rectangle()
                                .foregroundStyle(Color(UIColor.lightGray).opacity(0.2))
                                .frame(height: 50)
                            //                                    .rotationEffect(.degrees(70))
                                .offset(x: 142, y: 0)
                            
                            HStack {
                                Text("\(pokemonMoveData[i].moveDetail.name.capitalized)")
                                    .font(.system(size: 14))
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                    .padding()
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12))
                                    .padding(.trailing, 12)
                            }
                            .foregroundStyle(Color.black)
                            .fontWeight(.bold)
                            
                        }
                        .frame(height: 50)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .onTapGesture {
                            selectedMove = pokemonMoveData[i].moveDetail
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
            .sheet(item: $selectedMove) { move in
                PokemonMoveModalView(moveDetail: move)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    PokemonMoveView(pokemonName: "SampleMon", pokemonPortraitURLString: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/865.png", pokemonTypeData: ("normal", UIColor.systemMint), pokemonMoveData: [PokemonMoveData(moveDetail: PokemonMoveDetail(name: "thunder-punch", url: "https://pokeapi.co/api/v2/move/9/"))])
}
