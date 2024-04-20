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
    
    //for graph animation
    @State private var graphWidth: [CGFloat] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    //for いろち
    @State private var showingIrochiPortrait: Bool = false
    
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
                    
                    Rectangle()
                        .frame(width: 80, height: 30)
                        .foregroundStyle(Color(uiColor: getPokemonTypeImageAndColor(type: viewModel.pokemonData?.types[0].type.name ?? "Unknown").1))
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
                
                
                HStack {
                    Text(String(viewModel.pokemonData?.name.capitalized ?? ""))
                        .fontWeight(.bold)
                        .font(Font.system(size: 30))
                        
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
                
                Divider()
                    .padding(.bottom, 10)
                
                if let pokeStats = viewModel.pokemonData?.stats {
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
                                                    withAnimation(.easeOut(duration: 0.7).delay(0.3)) {
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
    
    //MARK: 책갈피 됨
    func getPokemonTypeImageAndColor(type: String) -> (String, UIColor) {
        
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
    PokemonDetailView(pokeData: PokemonListObject(name: "pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/"), endpoint: "https://pokeapi.co/api/v2/pokemon/25/")
}
