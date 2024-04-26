//
//  MainTabView.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/21/24.
//

import SwiftUI

struct MainGridView: View {
    
    private var gridItems: [GridItem] = [
        GridItem(.flexible(minimum: 100, maximum: .infinity)),
        GridItem(.flexible(minimum: 100, maximum: .infinity))
    ]
    
    var body: some View {
        NavigationStack {
            HStack {
                Image("pokedexIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24, alignment: .center)
                
                Text("PokeDex Project")
                    .font(Font.custom("Silkscreen-Regular", size: 24))
            }
            
            ScrollView {
                LazyVGrid(columns: gridItems) {
                    NavigationLink {
                        EntryView(viewModel: EntryViewModel(limit: 151, offset: 0),
                                  startFrom: 0)
                    } label: {
                        GenerationCellView(listRangeText: "0001-\n0151",
                                           bgImageName: "pokemonGen1BG",
                                           cellColor: Color(UIColor.systemYellow))
                    }
                    
                    NavigationLink {
                        EntryView(viewModel: EntryViewModel(limit: 100, offset: 151),
                                  startFrom: 151)
                    } label: {
                        GenerationCellView(listRangeText: "0152-\n0251",
                                           bgImageName: "pokemonGen2BG",
                                           cellColor: Color(UIColor.systemTeal))
                    }
                    
                    NavigationLink {
                        EntryView(viewModel: EntryViewModel(limit: 135, offset: 251),
                                  startFrom: 251)
                    } label: {
                        GenerationCellView(listRangeText: "0252-\n0386",
                                           bgImageName: "pokemonGen3BG",
                                           cellColor: Color(UIColor.systemMint))
                    }
                    
                    NavigationLink {
                        EntryView(viewModel: EntryViewModel(limit: 107, offset: 386),
                                  startFrom: 386)
                    } label: {
                        GenerationCellView(listRangeText: "0387-\n0493",
                                           bgImageName: "pokemonGen4BG",
                                           cellColor: Color(UIColor.systemBlue))
                    }
                    
                    NavigationLink {
                        EntryView(viewModel: EntryViewModel(limit: 156, offset: 493),
                                  startFrom: 493)
                    } label: {
                        GenerationCellView(listRangeText: "0494-\n0649",
                                           bgImageName: "pokemonGen5BG",
                                           cellColor: Color(UIColor.systemGray4))
                    }
                    
                    NavigationLink {
                        EntryView(viewModel: EntryViewModel(limit: 72, offset: 649),
                                  startFrom: 649)
                    } label: {
                        GenerationCellView(listRangeText: "0650-\n0721",
                                           bgImageName: "pokemonGen6BG",
                                           cellColor: Color(UIColor.systemGreen))
                    }
                    
                    NavigationLink {
                        EntryView(viewModel: EntryViewModel(limit: 88, offset: 721),
                                  startFrom: 721)
                    } label: {
                        GenerationCellView(listRangeText: "0722-\n0809",
                                           bgImageName: "pokemonGen7BG",
                                           cellColor: Color(UIColor.systemPink))
                    }
                    
                    NavigationLink {
                        EntryView(viewModel: EntryViewModel(limit: 96, offset: 809),
                                  startFrom: 809)
                    } label: {
                        GenerationCellView(listRangeText: "0810-\n0905",
                                           bgImageName: "pokemonGen8BG",
                                           cellColor: Color(UIColor.systemMint))
                    }
                    
                    NavigationLink {
                        EntryView(viewModel: EntryViewModel(limit: 120, offset: 905),
                                  startFrom: 905)
                    } label: {
                        GenerationCellView(listRangeText: "0906-\n1025",
                                           bgImageName: "pokemonGen9BG",
                                           cellColor: Color(UIColor.systemGreen))
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
}

struct GenerationCellView: View {
    
    let listRangeText: String
    let bgImageName: String
    let cellColor: Color
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .frame(height: 100)
            .foregroundStyle(cellColor.opacity(0.3))
            .overlay {
                ZStack {
                    Text(listRangeText)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .font(Font.custom("Silkscreen-Regular", size: 21))
                        .foregroundStyle(Color("textColor"))
                        .frame(maxWidth: .infinity, maxHeight: 80, alignment: .leading)
                        .padding()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(
                Image(bgImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .opacity(0.5)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            )
            .clipped()
    }
}

#Preview {
    MainGridView()
}
