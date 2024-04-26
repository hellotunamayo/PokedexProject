//
//  MainTabView.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/21/24.
//

import SwiftUI

struct MainTabView: View {
    
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
                                           cellColor: Color(UIColor(red: 250/255,
                                                                    green: 100/255,
                                                                    blue: 0/255,
                                                                    alpha: 1.0)))
                    }
                    
                    NavigationLink {
                        EntryView(viewModel: EntryViewModel(limit: 100, offset: 151),
                                  startFrom: 151)
                    } label: {
                        GenerationCellView(listRangeText: "0152-\n0251", cellColor: .red)
                    }
                    
                    NavigationLink {
                        EntryView(viewModel: EntryViewModel(limit: 135, offset: 251),
                                  startFrom: 251)
                    } label: {
                        GenerationCellView(listRangeText: "0252-\n0386", cellColor: .red)
                    }
                    
                    NavigationLink {
                        EntryView(viewModel: EntryViewModel(limit: 107, offset: 386),
                                  startFrom: 386)
                    } label: {
                        GenerationCellView(listRangeText: "0387-\n0493", cellColor: .red)
                    }
                    
                    NavigationLink {
                        EntryView(viewModel: EntryViewModel(limit: 156, offset: 493),
                                  startFrom: 493)
                    } label: {
                        GenerationCellView(listRangeText: "0494-\n0649", cellColor: .red)
                    }
                    
                    NavigationLink {
                        EntryView(viewModel: EntryViewModel(limit: 72, offset: 649),
                                  startFrom: 649)
                    } label: {
                        GenerationCellView(listRangeText: "0650-\n0721", cellColor: .red)
                    }
                    
                    NavigationLink {
                        EntryView(viewModel: EntryViewModel(limit: 88, offset: 721),
                                  startFrom: 721)
                    } label: {
                        GenerationCellView(listRangeText: "0722-\n0809", cellColor: .red)
                    }
                    
                    NavigationLink {
                        EntryView(viewModel: EntryViewModel(limit: 96, offset: 809),
                                  startFrom: 809)
                    } label: {
                        GenerationCellView(listRangeText: "0810-\n0905", cellColor: .red)
                    }
                    
                    NavigationLink {
                        EntryView(viewModel: EntryViewModel(limit: 120, offset: 905),
                                  startFrom: 905)
                    } label: {
                        GenerationCellView(listRangeText: "0906-\n1025", cellColor: .red)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
}

struct GenerationCellView: View {
    
    let listRangeText: String
    let cellColor: Color
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .frame(height: 100)
            .foregroundStyle(cellColor)
            .overlay {
                VStack {
                    Text(listRangeText)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .font(Font.custom("Silkscreen-Regular", size: 21))
                        .foregroundStyle(Color("textColor"))
                        .frame(maxWidth: .infinity, maxHeight: 80, alignment: .leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
    }
}

#Preview {
    MainTabView()
}
