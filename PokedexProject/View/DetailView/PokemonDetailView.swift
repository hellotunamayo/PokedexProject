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
    let gridItem: [GridItem] = [
        GridItem(.flexible(minimum: 30, maximum: 300)),
        GridItem(.flexible(minimum: 30, maximum: 300))
    ]
    
    //for いろち
    @State private var showingIrochiPortrait: Bool = false
    
    //audio player
    @State var audioPlayer: AVAudioPlayer!
    
    var body: some View {
        ScrollView {
            //Sprite View
            HStack {
                if let frontURL = URL(string: showingIrochiPortrait ? viewModel.pokemonData?.sprites.frontShiny ?? "" : viewModel.pokemonData?.sprites.frontDefault ?? "") {
                    PokemonSpriteView(imageUrl: frontURL, viewWidth: 100)
                } else {
                    ProgressView()
                }
                
                if let backURL = URL(string: showingIrochiPortrait ? viewModel.pokemonData?.sprites.backShiny ?? "" : viewModel.pokemonData?.sprites.backDefault ?? "") {
                    PokemonSpriteView(imageUrl: backURL, viewWidth: 100)
                } else {
                    ProgressView()
                }
            }
            .padding(.top, 120)
            .padding(.bottom, 30)
            
            //Content
            VStack {
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
                        .frame(width: 80, height: 30)
                        .foregroundStyle(
                            Color(getPokemonTypeImageAndColor(type: viewModel
                                                                    .pokemonData?.types[0]
                                                                    .type.name ?? "Unknown").typeColor)
                        )
                        .clipShape(.capsule)
                        .overlay {
                            Text(String(viewModel.pokemonData?.types[0].type.name ?? "Unknown").uppercased())
                                .foregroundStyle(Color.white)
                                .fontWeight(.bold)
                                .font(.caption)
                        }
                        .padding(.top, 30)
                    
                    //TODO: 나중에 타입 이미지로 갈기
//                    Image(systemName: getPokemonTypeImage(type: viewModel.pokemonData?.types[0].type.name ?? "Unknown"))
                }
                
                //MARK: 이름, 울음소리, 이로치전환
                HStack {
                    //이름
                    Text(String(viewModel.pokemonData?.name.capitalized ?? ""))
                        .fontWeight(.bold)
                        .font(Font.system(size: 30))
                    
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
                .padding(.bottom, 10)
                
                //디바이더
                Divider()
                    .padding(.bottom, 10)
                
                //MARK: 포켓몬 능력치 그래프
                if let pokeStats = viewModel.pokemonData?.stats {
                    PokemonDetailListView(pokeStats: pokeStats)
                    .padding(.horizontal, 30)
                } else {
                    ProgressView()
                }
                
                Spacer()
            }
            .frame(minWidth: 320, maxWidth: .infinity, minHeight: 700)
            .background(Color("detailViewSheetBackground"))
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
    
}

//MARK: Functions
extension PokemonDetailView {
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
    
    /// 포켓몬 타입 별 아이콘과 타입 별 색상을 튜플로 리턴
    func getPokemonTypeImageAndColor(type: String) -> (typeIconName: String, typeColor: UIColor) {
        
        //나중에 이걸로 바꾸자 https://github.com/duiker101/pokemon-type-svg-icons
        
        switch type {
            case "normal":
                return ("circle.circle", UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1))
            case "bug":
                return ("ant", UIColor(red: 132/255, green: 177/255, blue: 20/255, alpha: 1))
            case "dark":
                return ("lightbulb.slash", UIColor(red: 71/255, green: 69/255, blue: 79/255, alpha: 1))
            case "dragon":
                return ("lizard", UIColor(red: 17/255, green: 85/255, blue: 190/255, alpha: 1))
            case "electric":
                return ("battery.100.bolt", UIColor(red: 250/255, green: 170/255, blue: 51/255, alpha: 1))
            case "fairy":
                return ("ladybug", UIColor(red: 228/255, green: 120/255, blue: 226/255, alpha: 1))
            case "fighting":
                return ("figure.handball", UIColor(red: 194/255, green: 42/255, blue: 77/255, alpha: 1))
            case "fire":
                return ("flame", UIColor(red: 245/255, green: 17/255, blue: 54/255, alpha: 1))
            case "flying":
                return ("bird", UIColor(red: 145/255, green: 173/255, blue: 233/255, alpha: 1))
            case "ghost":
                return ("theatermasks", UIColor(red: 76/255, green: 88/255, blue: 177/255, alpha: 1))
            case "grass":
                return ("leaf", UIColor(red: 88/255, green: 179/255, blue: 64/255, alpha: 1))
            case "ground":
                return ("globe.europe.africa", UIColor(red: 189/255, green: 174/255, blue: 117/255, alpha: 1))
            case "ice":
                return ("snowflake", UIColor(red: 107/255, green: 200/255, blue: 180/255, alpha: 1))
            case "poison":
                return ("flask", UIColor(red: 163/255, green: 74/255, blue: 199/255, alpha: 1))
            case "psychic":
                return ("wifi", UIColor(red: 143/255, green: 145/255, blue: 141/255, alpha: 1))
            case "rock":
                return ("globe", UIColor(red: 204/255, green: 102/255, blue: 58/255, alpha: 1))
            case "steel":
                return ("scalemass", UIColor(red: 74/255, green: 132/255, blue: 146/255, alpha: 1))
            case "water":
                return ("drop", UIColor(red: 71/255, green: 139/255, blue: 218/255, alpha: 1))
            default:
                return ("xmark", UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1))
        }
    }
}

#Preview {
    PokemonDetailView(pokeData: PokemonListObject(name: "pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/"),
                                endpoint: "https://pokeapi.co/api/v2/pokemon/25/")
}
