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
    let pokemonMoveData: [PokemonMoveData]
    let gridItem: [GridItem] = [
        GridItem(.flexible(minimum: 30, maximum: 300)),
        GridItem(.flexible(minimum: 30, maximum: 300))
    ]
    
    var body: some View {
        NavigationStack {
            Text(pokemonName.capitalized)
                .font(.title)
                .fontWeight(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top, 10)
            
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
    }
}

#Preview {
    PokemonMoveView(pokemonName: "SampleMon", pokemonMoveData: [PokemonMoveData(moveDetail: PokemonMoveDetail(name: "thunder-punch", url: "https://pokeapi.co/api/v2/move/9/"))])
}
