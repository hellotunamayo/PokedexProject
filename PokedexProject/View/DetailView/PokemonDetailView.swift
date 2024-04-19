//
//  PokemonDetailView.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/18/24.
//

import SwiftUI
import AVFoundation
import OggDecoder

struct PokemonDetailView: View {
    
    var viewModel: PokemonDataViewModel = PokemonDataViewModel()
    let pokeData: PokemonListObject
    let endpoint: String
    
    @State var audioPlayer: AVAudioPlayer!
    
    var body: some View {
        ScrollView {
            HStack {
                if let frontURL = URL(string: viewModel.pokemonData?.sprites.frontDefault ?? "") {
                    PokemonSpriteView(imageUrl: frontURL, viewWidth: 100)
                } else {
                    ProgressView()
                }
                
                if let backURL = URL(string: viewModel.pokemonData?.sprites.backDefault ?? "") {
                    PokemonSpriteView(imageUrl: backURL, viewWidth: 100)
                } else {
                    ProgressView()
                }
            }
            .padding(.top, 120)
            .padding(.bottom, 30)
            
            VStack {
                Text("No. \(viewModel.pokemonData?.id ?? 0)")
                    .padding(.top, 30)
                
                Text(String(viewModel.pokemonData?.name.capitalized ?? ""))
                    .fontWeight(.bold)
                    .font(Font.system(size: 30))
                    .padding(.bottom, 30)
                
                Button(action: {
                    Task {
                        if let latestCry = viewModel.pokemonData?.cries.latest {
                            try await playDecodedOGGFromDownloadedLocation(localFileLocation: latestCry)
                        } else {
                            print("Failed to play audio")
                        }
                    }
                }, label: {
                    Text("Play")
                })
                
                if let pokeStats = viewModel.pokemonData?.stats {
                    ForEach(0..<pokeStats.count, id: \.self) { i in
                        if pokeStats[i].stat.name == "hp" {
                            Text(String(pokeStats[i].stat.name).uppercased())
                        } else {
                            Text(String(pokeStats[i].stat.name).capitalized)
                        }
                        
                        Text("\(pokeStats[i].baseStat)")
                    }
                } else {
                    ProgressView()
                }
                
                Spacer()
            }
            .frame(minWidth: 320, maxWidth: .infinity, minHeight: 1000)
            .background(Color.white)
            .clipShape(.rect(topLeadingRadius: 50, topTrailingRadius: 50, style: .continuous))
            .onAppear {
                Task {
                    try await viewModel.fetch(urlString: endpoint)
                }
            }
        }
        .border(Color.black)
        .background(
            Image("detailViewBg")
                .resizable()
                .aspectRatio(contentMode: .fill)
        )
        .ignoresSafeArea()
    }
    
    func playDecodedOGGFromDownloadedLocation(localFileLocation localURLString: String) async throws -> () {
        let url = try await viewModel.downloadFromURL(urlString: localURLString)
        let oggDecoder = OGGDecoder()
        let decodedOGG = await oggDecoder.decode(url)
        if let tempWavFile = decodedOGG {
            print("tempWavFile: \(tempWavFile)")
            let documentsURL = try FileManager.default.url(for: .documentDirectory,
                                                           in: .userDomainMask,
                                                           appropriateFor: nil,
                                                           create: false)
            let savedURL = documentsURL
                .appendingPathComponent(tempWavFile.lastPathComponent)
            
            do {
                try? FileManager.default.removeItem(at: savedURL)
                try FileManager.default.moveItem(at: tempWavFile, to: savedURL)
                print("savedURL: \(savedURL)")
                audioPlayer = try! AVAudioPlayer(contentsOf: savedURL)
                audioPlayer.play()
            } catch {
                print("play error: \(error)")
            }
        }
    }
    
}

//#Preview {
//    PokemonDetailView()
//}
