//
//  PokemonDetailView.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/18/24.
//

import SwiftUI

struct PokemonDetailView: View {
    
    @State private var isModalShowing: Bool = false
    @State private var localizationIndex: (nameIndex: Int, nickIndex: Int) = (8, 7)
    @State private var pokemonMoveData = [PokemonMoveData]()
    @State private var showingIrochiPortrait: Bool = false
    @State private var selectedMove: PokemonMoveDetail?
    @State private var selectedLocale: Locale = .ko
    
    var viewModel: PokemonDataViewModel = PokemonDataViewModel()
    let pokeData: PokemonListObject
    let endpoint: String
    let gridItem: [GridItem] = [
        GridItem(.flexible(minimum: 30, maximum: 300)),
        GridItem(.flexible(minimum: 30, maximum: 300))
    ]
    
    //onappear animation
    @State var opacity: CGFloat = 0.0
    @State var offsetY: CGFloat = 30
    
    var body: some View {
        ScrollView {
            //MARK: 초상화
            HStack {
                if let frontURL = URL(string: showingIrochiPortrait ? viewModel.pokemonData?.sprites.frontShiny ?? "" : viewModel.pokemonData?.sprites.frontDefault ?? "") {
                    PokemonSpriteView(imageUrl: frontURL, viewWidth: 100)
                }
                
                if let backURL = URL(string: showingIrochiPortrait ? viewModel.pokemonData?.sprites.backShiny ?? "" : viewModel.pokemonData?.sprites.backDefault ?? "") {
                    PokemonSpriteView(imageUrl: backURL, viewWidth: 100)
                }
            }
            .padding(.top, 100)
            .padding(.bottom, 30)
            
            //Content
            VStack {
                //MARK: 넘버, 타입, 이름, 별명, 체중, 신장
                PokemonDetailOverviewView(localizationIndex: $localizationIndex,
                                          showingIrochiPortrait: $showingIrochiPortrait,
                                          localization: selectedLocale,
                                          viewModel: viewModel)
                
                
                Divider()
                    .padding(.bottom, 10)
                
                //MARK: 능력치
                VStack {
                    Group {
                        Text("Basic Status")
                            .font(.title2)
                            .fontWeight(.black)
                            
                        Rectangle()
                            .frame(width: 20, height: 3)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if let pokeStats = viewModel.pokemonData?.stats {
                        PokemonDetailGraphView(pokeStats: pokeStats)
                            .padding(.vertical, 10)
                    } else {
                        ProgressView()
                    }
                }
                .padding(.horizontal, 30)
                
                Divider()
                    .padding(.vertical, 10)
                
                //MARK: 기술일람
                VStack {
                    Group {
                        Text("Moves")
                            .font(.title2)
                            .fontWeight(.black)
                        
                        Rectangle()
                            .frame(width: 20, height: 3)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    //기술 리스트
                    LazyVGrid(columns: gridItem) {
                        ForEach(0..<pokemonMoveData.count, id: \.self) { i in
                            ZStack {
                                Rectangle()
                                    .foregroundStyle(Color(UIColor.pokeBrightGray))
                                Rectangle()
                                    .foregroundStyle(Color(UIColor.lightGray).opacity(0.2))
                                    .frame(height: 100)
                                    .rotationEffect(.degrees(70))
                                    .offset(x: 90, y: -10)
                                    
                                Text("\(pokemonMoveData[i].moveDetail.name.capitalized)")
                                    .foregroundStyle(Color.black)
                                    .fontWeight(.bold)
                                    .font(.system(size: 14))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                            }
                            .frame(height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .onTapGesture {
                                selectedMove = pokemonMoveData[i].moveDetail
                            }
                        }
                    }
                    .padding(.top, 10)
                }
                .padding(EdgeInsets(top: 10, leading: 30, bottom: 60, trailing: 30))
                .sheet(item: $selectedMove) { move in
                    PokemonMoveModalView(moveDetail: move)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 700, maxHeight: .infinity, alignment: .leading)
            .background(Color("detailViewSheetBackground"))
            .clipShape(.rect(topLeadingRadius: 50, topTrailingRadius: 50, style: .continuous))
        }
        .opacity(opacity)
        .offset(x: 0, y: offsetY)
        .background(
            Image("detailViewBg")
                .resizable()
                .aspectRatio(contentMode: .fill)
        )
        .ignoresSafeArea()
        .safeAreaInset(edge: .top, content: {
            Color.clear
        })
        .task {
            do {
                try await viewModel.fetch(urlString: endpoint)
                if let moveData = viewModel.pokemonData?.moves {
                    pokemonMoveData = moveData
                } else {
                    pokemonMoveData = []
                }
            } catch {
                pokemonMoveData = []
            }
            
            withAnimation(.easeOut(duration: 0.25).delay(0.3)) {
                offsetY = 0
                opacity = 1
            }
        }
        .toolbar {
            ToolbarItem {
                Picker(selection: $selectedLocale) {
                    Text("한국어")
                        .tag(Locale.ko)
                    Text("일본어")
                        .tag(Locale.jp)
                    Text("영어")
                        .tag(Locale.en)
                    Text("중국어")
                        .tag(Locale.cn)
                    Text("독일어")
                        .tag(Locale.de)
                } label: {
                    Image(systemName: "globe")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(Color("textColor"))
                        .frame(width: 22, height: 22)
                        .offset(x: 5, y: 2)

                }
            }
        }
//        .toolbar {
//            ToolbarItem(placement: .topBarTrailing) {
//                //다국어 이름정보
//                Picker(selection: $localizationIndex.nameIndex) {
//                    Text("English")
//                        .tag(8)
//                    Text("日本語")
//                        .tag(0)
//                    Text("한국어")
//                        .tag(2)
//                    Text("繁体字")
//                        .tag(3)
//                    Text("简体字")
//                        .tag(10)
//                    Text("Français")
//                        .tag(4)
//                    Text("Deutsch")
//                        .tag(5)
//                    Text("Español")
//                        .tag(6)
//                    Text("Italiano")
//                        .tag(7)
//                } label: {
//                    Image(systemName: "globe")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .foregroundStyle(Color("textColor"))
//                        .frame(width: 22, height: 22)
//                        .offset(x: 5, y: 2)
//                }
//                .onChange(of: localizationIndex.nameIndex) { oldValue, newValue in
//                    switch newValue {
//                        case 0: //일본어
//                            localizationIndex.nickIndex = 0
//                        default: //그외 언어
//                            localizationIndex.nickIndex = newValue - 1
//                    }
//                }
//            }
//        }
    }
    
}

#Preview {
    NavigationStack {
        PokemonDetailView(pokeData: PokemonListObject(name: "pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/"),
                                    endpoint: "https://pokeapi.co/api/v2/pokemon/25/")
    }
}
