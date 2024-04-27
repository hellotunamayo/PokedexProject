//
//  SearchViewCell.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/27/24.
//

import SwiftUI

struct SearchViewCell: View {
    
    @State private var pokemonPortraitURL: URL?
    @State private var pokemonName: String?
    @State private var dominantColor: Color?
    @State private var pokemonIndexNumber: Int?
    
    let endpoint: String
    
    var body: some View {
        HStack {
            VStack {
                Capsule()
                    .foregroundStyle(Color.black)
                    .frame(width: 90, height: 30)
                    .overlay {
                        Text("No. \(pokemonIndexNumber ?? 0)")
                            .foregroundStyle(Color.white)
                            .font(.system(size: 12))
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .offset(x: -5, y: -2)
                
                Text(pokemonName?.capitalized ?? "N/A")
                    .lineLimit(1)
                    .minimumScaleFactor(0.2)
                    .font(.title)
                    .fontWeight(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .offset(y: -5)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)
            
            Spacer()
            AsyncImage(url: pokemonPortraitURL)
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 110, maxHeight: 110)
        }
        .frame(maxWidth: .infinity, minHeight: 120, maxHeight: 120)
        .background(dominantColor?.opacity(0.2) ?? Color.background.opacity(0.2))
        .task {
            do {
                try await loadData()
            } catch {
                print(error)
            }
        }
    }
    
    func loadData() async throws {
        do {
            guard let url = URL(string: endpoint) else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            let jsonData = try JSONDecoder().decode(PokemonDetailData.self, from: data)
            if let portraitURL = URL(string: jsonData.sprites.frontDefault) {
                let uiColor = try await getColorFromImage(urlString: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(jsonData.id).png")
                
                pokemonPortraitURL = portraitURL
                pokemonName = jsonData.name
                dominantColor = Color(uiColor)
                pokemonIndexNumber = jsonData.id
            }
        } catch {
            print("An error occurred while fetch data: \(error)")
        }
    }
}

#Preview {
    SearchViewCell(endpoint: "https://pokeapi.co/api/v2/pokemon/1020/")
}
