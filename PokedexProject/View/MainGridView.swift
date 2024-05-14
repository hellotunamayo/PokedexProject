//
//  MainTabView.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/21/24.
//

import SwiftUI
import CoreMotion

struct MainGridView: View {
    @Environment(\.pokemonAPIService) private var service
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
                        EntryView(viewModel: EntryViewModel(limit: 151, offset: 0, service: service),
                                  startFrom: 0)
                    } label: {
                        GenerationCellView(listRangeText: "0001-\n0151",
                                           bgImageName: "pokemonGen1BG",
                                           cellColor: Color(UIColor.systemYellow),
                                           originX: 50,
                                           originY: -30)
                    }
                    
                    NavigationLink {
                        EntryView(viewModel: EntryViewModel(limit: 100, offset: 151, service: service),
                                  startFrom: 151)
                    } label: {
                        GenerationCellView(listRangeText: "0152-\n0251",
                                           bgImageName: "pokemonGen2BG",
                                           cellColor: Color(UIColor.systemTeal),
                                           originX: 50,
                                           originY: -20)
                    }
                    
                    NavigationLink {
                        EntryView(viewModel: EntryViewModel(limit: 135, offset: 251, service: service),
                                  startFrom: 251)
                    } label: {
                        GenerationCellView(listRangeText: "0252-\n0386",
                                           bgImageName: "pokemonGen3BG",
                                           cellColor: Color(UIColor.systemMint),
                                           originX: 80,
                                           originY: -50)
                    }
                    
                    NavigationLink {
                        EntryView(viewModel: EntryViewModel(limit: 107, offset: 386, service: service),
                                  startFrom: 386)
                    } label: {
                        GenerationCellView(listRangeText: "0387-\n0493",
                                           bgImageName: "pokemonGen4BG",
                                           cellColor: Color(UIColor.systemBlue),
                                           originX: 80,
                                           originY: -20)
                    }
                    
                    NavigationLink {
                        EntryView(viewModel: EntryViewModel(limit: 156, offset: 493, service: service),
                                  startFrom: 493)
                    } label: {
                        GenerationCellView(listRangeText: "0494-\n0649",
                                           bgImageName: "pokemonGen5BG",
                                           cellColor: Color(UIColor.systemGray4),
                                           originX: 80,
                                           originY: -10)
                    }
                    
                    NavigationLink {
                        EntryView(viewModel: EntryViewModel(limit: 72, offset: 649, service: service),
                                  startFrom: 649)
                    } label: {
                        GenerationCellView(listRangeText: "0650-\n0721",
                                           bgImageName: "pokemonGen6BG",
                                           cellColor: Color(UIColor.systemGreen),
                                           originX: 50,
                                           originY: -30)
                    }
                    
                    NavigationLink {
                        EntryView(viewModel: EntryViewModel(limit: 88, offset: 721, service: service),
                                  startFrom: 721)
                    } label: {
                        GenerationCellView(listRangeText: "0722-\n0809",
                                           bgImageName: "pokemonGen7BG",
                                           cellColor: Color(UIColor.systemPink),
                                           originX: 80,
                                           originY: -30)
                    }
                    
                    NavigationLink {
                        EntryView(viewModel: EntryViewModel(limit: 96, offset: 809, service: service),
                                  startFrom: 809)
                    } label: {
                        GenerationCellView(listRangeText: "0810-\n0905",
                                           bgImageName: "pokemonGen8BG",
                                           cellColor: Color(UIColor.systemMint),
                                           originX: 90,
                                           originY: -30)
                    }
                    
                    NavigationLink {
                        EntryView(viewModel: EntryViewModel(limit: 120, offset: 905, service: service),
                                  startFrom: 905)
                    } label: {
                        GenerationCellView(listRangeText: "0906-\n1025",
                                           bgImageName: "pokemonGen9BG",
                                           cellColor: Color(UIColor.systemGreen),
                                           originX: 60,
                                           originY: -20)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
}

//MARK: 그리드 셀
struct GenerationCellView: View {
    
    @State private var roll: Double = 0.0
    @State private var pitch: Double = 0.0
    
    let motionManager: CMMotionManager = CMMotionManager()
    let listRangeText: String
    let bgImageName: String
    let cellColor: Color
    let originX: CGFloat
    let originY: CGFloat
    
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
                GeometryReader { geometry in
                    Image(bgImageName)
                        .resizable()
                        .offset(x: originX + roll * 20, y: originY + pitch * 20)
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: geometry.size.height + 50, maxHeight: geometry.size.height + 50)
                        .opacity(0.5)
                        .onAppear {
                            startGettingDeviceMotion()
                        }
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
    }
    
    func startGettingDeviceMotion() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.01
            motionManager.startDeviceMotionUpdates(to: .main) { motion, error in
                guard let validMotion = motion else { return }
                roll = validMotion.attitude.roll
                pitch = validMotion.attitude.pitch
//                print("roll: \(roll * 20) / pitch: \(pitch * 20)")
            }
        }
    }
}

#Preview {
    MainGridView()
}
