//
//  PokemonDetailListView.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/20/24.
//

import SwiftUI

struct PokemonDetailGraphView: View {
    
    //for graph animation
    @State private var graphWidth: [CGFloat] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    
    //for animation when onappear
    @State private var offsetY: CGFloat = 30.0
    @State private var opacity: CGFloat = 0.0
    
    let pokeStats: [PokemonStat]
    let gridItem: [GridItem] = [
        GridItem(.flexible(minimum: 30, maximum: 300)),
        GridItem(.flexible(minimum: 30, maximum: 300))
    ]
    
    var body: some View {
        LazyVGrid(columns: gridItem){
            ForEach(0..<pokeStats.count, id: \.self) { i in
                HStack {
                    if pokeStats[i].stat.name == "hp" {
                        Text(String(pokeStats[i].stat.name).uppercased())
                            .fontWeight(.bold)
                    } else {
                        Text(String(pokeStats[i].stat.name).capitalized)
                            .fontWeight(.bold)
                    }
                    Spacer()
                }
                .padding(.bottom, 10)
                
                ZStack {
                    Rectangle()
                        .foregroundStyle(Color(uiColor:UIColor(red: 220/255,
                                                               green: 220/255,
                                                               blue: 220/255,
                                                               alpha: 0.3)))
                        .overlay{
                            GeometryReader { proxy in
                                let graphValue = calculateGraphWidth(maxWidth: proxy.frame(in: .local).width,
                                                                     status: CGFloat(pokeStats[i].baseStat))
                                Rectangle()
                                    .foregroundStyle(graphValue.1)
                                    .frame(width: graphWidth[i],
                                           height: proxy.frame(in: .local).height)
                                    .onAppear {
                                        withAnimation(.easeOut(duration: 0.7).delay(0.9)) {
                                            graphWidth[i] = graphValue.0
                                        }
                                    }
                            }
                        }
                        .clipShape(.capsule)
                    
                    Text("\(pokeStats[i].baseStat)")
                        .fontWeight(.semibold)
                        .font(Font.footnote)
                        .foregroundStyle(Color.white)
                        .blendMode(.difference)
                        .frame(minWidth: 100, maxWidth: .infinity)
                }
            }
        }
        .offset(x: 0, y: offsetY)
        .opacity(opacity)
        .onAppear {
            withAnimation(.easeOut(duration: 0.3).delay(0.7)) {
                offsetY = 0
                opacity = 1
            }
        }
    }
    
    func calculateGraphWidth(maxWidth: CGFloat, status: CGFloat) -> (CGFloat, Color) {
        let modifier: CGFloat = status / CGFloat(255.0)
        var color: Color
        
        let percentage = Double(status) / 200
        if 0..<0.2 ~= percentage {
            color = Color(UIColor(red: 230/255, green: 64/255, blue: 38/255, alpha: 1))
        } else if 0.2..<0.4 ~= percentage {
            color = Color(UIColor(red: 240/255, green: 137/255, blue: 19/255, alpha: 1))
        } else if 0.4..<0.6 ~= percentage {
            color = Color(UIColor(red: 240/255, green: 210/255, blue: 19/255, alpha: 1))
        } else if 0.6..<0.8 ~= percentage {
            color = Color(UIColor(red: 101/255, green: 200/255, blue: 19/255, alpha: 1))
        } else {
            color = Color(UIColor(red: 19/255, green: 240/255, blue: 140/255, alpha: 1))
        }
        
        return (maxWidth * modifier, color)
    }
    
}

#Preview {
    PokemonDetailGraphView(pokeStats: [
        PokemonStat(baseStat: 50, effort: 0, stat: PokemonStatType(name: "HP", url: "")),
        PokemonStat(baseStat: 150, effort: 0, stat: PokemonStatType(name: "Sample stat", url: "")),
        PokemonStat(baseStat: 240, effort: 0, stat: PokemonStatType(name: "Another Stat", url: "")),
        PokemonStat(baseStat: 100, effort: 0, stat: PokemonStatType(name: "Third Stat", url: ""))
    ])
}
