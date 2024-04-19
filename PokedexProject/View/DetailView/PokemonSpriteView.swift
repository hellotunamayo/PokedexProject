//
//  PokemonSpriteView.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/19/24.
//

import SwiftUI

struct PokemonSpriteView: View {
    let imageUrl: URL
    let viewWidth: CGFloat
    var body: some View {
        AsyncImage(url: imageUrl) { image in
            ZStack {
                Rectangle()
                    .fill(Color(uiColor: UIColor(red: 213/255, green: 50/255, blue: 50/255, alpha: 0.2)))
                    .padding(.top, viewWidth / 2)
                image
            }
        } placeholder: {
            ProgressView()
        }
        .frame(width: viewWidth, height: viewWidth, alignment: .center)
        .background(Color.white)
        .clipShape(.circle)
        .aspectRatio(contentMode: .fit)
    }
}
