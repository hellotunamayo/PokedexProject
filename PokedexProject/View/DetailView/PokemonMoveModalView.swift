//
//  PokemonMoveModalView.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/22/24.
//

import SwiftUI

struct PokemonMoveModalView: View {
    
    @Environment (\.dismiss) var dismiss
    @State var moveData: PokemonMoveDetailExtended?
    
    let moveDetail: PokemonMoveDetail
    let gridItem: [GridItem] = [
        GridItem(.flexible(minimum: 50)),
        GridItem(.flexible(minimum: 50)),
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Group {
                        Text("Names")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(Font.system(size: 30))
                            .fontWeight(.black)
                        
                        Rectangle()
                            .frame(width: 30, height: 3)
                            .padding(.bottom, 5)
                        
                        LazyVGrid(columns: gridItem) {
                            if let moveNames = moveData?.names {
                                let compactedMoveName = Array(Set(moveNames.compactMap{$0}))
                                ForEach(compactedMoveName, id: \.self) { moveName in
                                    Text("\(moveName.name ?? "...")")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(Font.system(size: 20))
                                        .fontWeight(.bold)
                                        .padding(.vertical, 1)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    PokemonMoveModalDivider()
                    
                    LazyVGrid(columns: gridItem) {
                        Text("Damage Class")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.title3)
                            .fontWeight(.black)
                        
                        Text("\(moveData?.damageClass?.name.capitalized ?? "...")")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.body)
                    }
                    
                    PokemonMoveModalDivider()
                    
                    LazyVGrid(columns: gridItem) {
                        Text("Power")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.title3)
                            .fontWeight(.black)
                        
                        Text("\(moveData?.power ?? 0)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.body)
                    }
                    
                    PokemonMoveModalDivider()
                    
                    LazyVGrid(columns: gridItem) {
                        Text("PP")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.title3)
                            .fontWeight(.black)
                        
                        Text("\(moveData?.pp ?? 0)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.body)
                    }
                    
                    PokemonMoveModalDivider()
                    
                    LazyVGrid(columns: gridItem) {
                        Text("Accuracy")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.title3)
                            .fontWeight(.black)
                        
                        Text("\(moveData?.accuracy ?? 0)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.body)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding()
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            dismiss()
                        }, label: {
                            Text("Close")
                        })
                    }
                }
                .task {
                    do {
                        guard let url = URL(string: moveDetail.url) else { return }
                        let (data, _) = try await URLSession.shared.data(from: url)
                        let jsonData = try! JSONDecoder().decode(PokemonMoveDetailExtended.self, from: data)
                        moveData = jsonData
                    } catch {
                        moveData = PokemonMoveDetailExtended(accuracy: 0, damageClass: PokemonDamageClass(name: "...", url: ""), power: 0, pp: 0, names: [], type: PokemonMoveType(name: "", url: ""))
                    }
            }
            }
        }
    }
    
}

struct PokemonMoveModalDivider: View {
    
    var body: some View {
        Divider()
            .padding(.vertical, 10)
    }
    
}

#Preview {
    PokemonMoveModalView(moveDetail: PokemonMoveDetail(name: "mega-punch",  url: "https://pokeapi.co/api/v2/move/5/"))
}
