//
//  PokemonDetailOverviewView.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/22/24.
//

import SwiftUI
import AVFoundation
import OggDecoder

struct PokemonDetailOverviewView: View {
    
    @Binding var localizationIndex: (nameIndex: Int, nickIndex: Int)
    @Binding var showingIrochiPortrait: Bool
    
    @State var audioPlayer: AVAudioPlayer!
    
    let viewModel: PokemonDataViewModel
    
    var body: some View {
        HStack {
            //MARK: 도감넘버
            Rectangle()
                .frame(width: 90, height: 30)
                .foregroundStyle(Color.black)
                .clipShape(.capsule)
                .overlay {
                    Text("No. \(viewModel.pokemonData?.id ?? 0)")
                        .foregroundStyle(Color.white)
                        .fontWeight(.bold)
                        .font(.footnote)
                }
                .padding(.top, 30)
            
            //MARK: 타입
            Rectangle()
                .frame(width: 110, height: 30)
                .foregroundStyle(
                    Color(viewModel.getPokemonTypeImageAndColor(type: viewModel
                        .pokemonData?.types[0]
                        .type.name ?? "normal").typeColor)
                )
                .clipShape(.capsule)
                .overlay {
                    HStack {
                        Image("\(viewModel.getPokemonTypeImageAndColor(type: viewModel.pokemonData?.types[0].type.name ?? "normal").0)")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16, alignment: .center)
                            .foregroundStyle(Color.white)
                            .offset(x: 2)
                        
                        Text(String(viewModel.pokemonData?.types[0].type.name ?? "normal").uppercased())
                            .foregroundStyle(Color.white)
                            .fontWeight(.bold)
                            .font(.caption)
                            .offset(x: -2)
                    }
                }
                .padding(.top, 30)
        }
        
        //MARK: 이름, 울음소리, 이로치전환
        HStack {
            //이름
//            Text(String(viewModel.pokemonSpeciesData?.names[localizationIndex.nameIndex].name.capitalized ?? ""))
            Text(String(viewModel.pokemonSpeciesData?.names[7].name.capitalized ?? ""))
                .fontWeight(.heavy)
                .font(Font.system(size: 28))
                .baselineOffset(localizationIndex.nameIndex < 4 || localizationIndex.nameIndex == 10 ? -2.0 : 0.0)
            
            //울음소리
            Button(action: {
                Task {
                    if let latestCry = viewModel.pokemonData?.cries.latest {
                        try await playDecodedOGGFromDownloadedLocation(localFileLocation: latestCry)
                    } else {
                        print("Failed to play audio")
                    }
                }
            }, label: {
                Image(systemName: "play.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(Color("textColor"))
                    .frame(width: 22, height: 22)
                    .offset(x: 5, y: 2)
            })
            
            //이로치 전환
            Button(action: {
                showingIrochiPortrait.toggle()
            }, label: {
                Image(systemName: showingIrochiPortrait ? "paintpalette.fill" : "paintpalette")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(Color("textColor"))
                    .frame(width: 22, height: 22)
                    .offset(x: 10, y: 2)
            })
        }
        
        //MARK: 별명
//        if let genus = viewModel.pokemonSpeciesData?.genera[safe: localizationIndex.nickIndex]?.genus {
//            Text("\(genus)")
//                .font(.system(size: 12))
//                .fontWeight(.bold)
//                .foregroundStyle(Color.gray)
//                .padding(EdgeInsets(top: -10, leading: 0, bottom: 10, trailing: 0))
//        }
        
        
        Rectangle()
            .frame(width: 20, height: 3, alignment: .center)
            .offset(y: -2)
        
        //MARK: 체중/신장
        VStack {
            HStack {
                HStack {
                    Circle()
                        .foregroundStyle(Color.black)
                        .frame(width: 20, height: 20, alignment: .center)
                        .overlay {
                            Image(systemName: "ruler")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 12, height: 12, alignment: .center)
                                .foregroundStyle(Color.white)
                                .rotationEffect(Angle(degrees: -45))
                            
                        }
                        .offset(x: 3)
                    
                    Text("\(viewModel.pokemonData?.height ?? 0)ft.")
                        .font(.system(size: 12))
                        .fontWeight(.semibold)
                }
                
                HStack {
                    Circle()
                        .foregroundStyle(Color.black)
                        .frame(width: 20, height: 20, alignment: .center)
                        .overlay {
                            Image(systemName: "scalemass")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 11, height: 11, alignment: .center)
                                .foregroundStyle(Color.white)
                            
                        }
                        .offset(x: 3)
                    
                    Text("\(viewModel.pokemonData?.weight ?? 0)lbs.")
                        .font(.system(size: 12))
                        .fontWeight(.semibold)
                }
            }
            .padding(.vertical, 10)
        }
        .padding(.bottom, 10)
    }
}

extension PokemonDetailOverviewView {
    //오디오 플레이백
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

#Preview {
    PokemonDetailOverviewView(localizationIndex: .constant((nameIndex: 1, nickIndex: 1)),
                              showingIrochiPortrait: .constant(false),
                              viewModel: PokemonDataViewModel())
}
