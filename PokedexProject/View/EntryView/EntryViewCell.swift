//
//  EntryViewCell.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/20/24.
//

import SwiftUI

struct EntryViewCell: View {
    @StateObject private var pokemonPortraitDispatcher = PokemonPortraitDispatcher()
    @State private var portraitOffsetX: CGFloat = 50.0
    @State private var cellOpacity: CGFloat = 0.0
    
    private var adjustedTextColor: UIColor {
        var h: CGFloat = 0.0,
            s: CGFloat = 0.0,
            b: CGFloat = 0.0,
            a: CGFloat = 0.0
        if pokemonPortraitDispatcher.backgroundColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a) {
            b += 0.9
            b = max(min(b, 1.0), 0.0)
            return UIColor(hue: h, saturation: s, brightness: b, alpha: a)
        }
        return UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    let index: Int
    let pokemonName: String
    
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                Rectangle()
                    .frame(width: 600, height: 300)
                    .foregroundStyle(
                        Color(pokemonPortraitDispatcher.backgroundColor)
                            .opacity(0.2)
                    )
                    .rotationEffect(Angle(degrees: 60))
                    .offset(x: 110, y: -60)
                
                //MARK: 포켓몬 이름
                VStack(alignment: .leading) {
                    //도감넘버
                    Capsule()
                        .foregroundStyle(Color.black)
                        .frame(width: 70, height: 24, alignment: .leading)
                        .overlay {
                            Text("No.\(index + 1)")
                                .font(Font.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.white)
                        }
                        .offset(x: 12, y: 30.0)
                    
                    //이름
                    Text(pokemonName.capitalized)
                        .frame(width: proxy.frame(in: .local).width / 2, alignment: .leading)
                        .padding()
                        .fontWeight(.heavy)
                        .font(Font.system(size: 30))
                        .foregroundStyle(Color(adjustedTextColor))
                        .lineLimit(1)
                        .minimumScaleFactor(0.2)
                        .offset(y: 15)
                }
                
                //MARK: 포켓몬 이미지
                Group {
                    if let image = pokemonPortraitDispatcher.image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 140, height: 140)
                            .onAppear {
                                withAnimation(.easeOut(duration: 0.3).delay(0.1)) {
                                    portraitOffsetX = 0
                                }
                            }
                    } else {
                        ProgressView()
                    }
                }
                .onAppear {
                    if pokemonPortraitDispatcher.image == nil {
                        pokemonPortraitDispatcher.load(with: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(index+1).png")
                    }
                }
                .onDisappear {
                    pokemonPortraitDispatcher.cancel()
                }
                .offset(x: proxy.frame(in: .local).maxX - (140 - portraitOffsetX), y: proxy.frame(in: .local).maxY - 140)
            }
            .frame(minWidth: 200, maxWidth: .infinity)
            .clipShape(.rect)
            .backgroundStyle(Color(pokemonPortraitDispatcher.backgroundColor))
            .background(Color(pokemonPortraitDispatcher.backgroundColor).opacity(0.1))
        }
        .opacity(cellOpacity)
        .background(Color.black)
        .onAppear {
            withAnimation(.easeOut(duration: 0.75)) {
                cellOpacity = 1.0
            }
        }
    }

}

#Preview {
    EntryViewCell(index: 24, pokemonName: "Pikachu")
        .frame(height: 140)
}
