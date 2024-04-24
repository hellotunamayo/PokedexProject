//
//  PokemonDetailView.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/18/24.
//

import SwiftUI

struct PokemonDetailView: View {
    
    @State private var isModalShowing: Bool = false
    @State private var pokemonMoveData = [PokemonMoveData]()
    @State private var showingIrochiPortrait: Bool = false
    @State private var selectedMove: PokemonMoveDetail?
    @State private var selectedLocale: Locale = .en
    
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
                PokemonDetailOverviewView(
                    showingIrochiPortrait: $showingIrochiPortrait,
                    localization: selectedLocale,
                    viewModel: viewModel
                )
                
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
                    
                    Spacer()
                }
                .padding(EdgeInsets(top: 10, leading: 30, bottom: 60, trailing: 30))
                .sheet(item: $selectedMove) { move in
                    PokemonMoveModalView(moveDetail: move)
                }
            }
            .frame(maxWidth: .infinity, minHeight: UIWindow().frame.height, maxHeight: .infinity, alignment: .leading)
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
                    Text("English")
                        .tag(Locale.en)
                    Text("日本語")
                        .tag(Locale.jp)
                    Text("한국어")
                        .tag(Locale.ko)
                    Text("Chinese-Traditional")
                        .tag(Locale.cn)
                    Text("Deutsch")
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
    }
    
}

#Preview {
    NavigationStack {
        PokemonDetailView(pokeData: PokemonListObject(name: "pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/"),
                                    endpoint: "https://pokeapi.co/api/v2/pokemon/25/")
    }
}
