//
//  PokemonMoveModalView.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/22/24.
//

import SwiftUI

struct PokemonMoveModalView: View {
    
    @Binding var isModalShowing: Bool
    @State var moveData: PokemonMoveDetailExtended?
    
    let enName: String
    let endPoint: String
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("\(enName.capitalized)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(Font.system(size: 30))
                    .fontWeight(.black)
                
                Text("\(moveData?.damageClass?.name.capitalized ?? "N/A")")
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
                        isModalShowing.toggle()
                    }, label: {
                        Text("Close")
                    })
                }
            }
            .task {
                do {
                    guard let url = URL(string: endPoint) else { return }
                    let (data, _) = try await URLSession.shared.data(from: url)
                    let jsonData = try! JSONDecoder().decode(PokemonMoveDetailExtended.self, from: data)
                    moveData = jsonData
                } catch {
                    moveData = PokemonMoveDetailExtended(accuracy: 0, damageClass: PokemonDamageClass(name: "", url: ""), power: 0, pp: 0, names: [])
                }
            }
        }
    }
}

#Preview {
    PokemonMoveModalView(isModalShowing: .constant(true), enName: "mol?lu", endPoint: "https://pokeapi.co/api/v2/move/5")
}
