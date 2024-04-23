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
                
                Divider()
                    .padding(.vertical, 10)
                
                Text("\(moveData?.damageClass?.name.capitalized ?? "...")")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(Font.system(size: 30))
                    .fontWeight(.black)
                
                Text("Accuracy: \(moveData?.accuracy ?? 0)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(Font.system(size: 30))
                    .fontWeight(.black)
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
                    moveData = PokemonMoveDetailExtended(accuracy: 0, damageClass: PokemonDamageClass(name: "...", url: ""), power: 0, pp: 0, names: [])
                }
            }
        }
    }
}

#Preview {
    PokemonMoveModalView(moveDetail: PokemonMoveDetail(name: "mega-punch",  url: "https://pokeapi.co/api/v2/move/5/"))
}
