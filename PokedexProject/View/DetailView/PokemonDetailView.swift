//
//  PokemonDetailView.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/18/24.
//

import SwiftUI

struct PokemonDetailView: View {
    
    @State private var isModalShowing: Bool = false
    @State private var showingIrochiPortrait: Bool = false
    
    @State private var selectedLocale: Locale = .en
    
    var viewModel: PokemonDetailViewModel = PokemonDetailViewModel()
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
                
                //TODO: 반복되는 뷰코드 단축할 방법을 찾을것..
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
                    NavigationLink {
                        PokemonMoveView(pokemonName: viewModel.pokemonData?.name ?? "", 
                                        pokemonPortraitURLString: viewModel.pokemonData?.sprites.frontDefault ?? "",
                                        pokemonTypeData: viewModel.getPokemonTypeImageAndColor(type: viewModel.pokemonData?.types[0].type.name ?? "normal"),
                                        pokemonMoveData: viewModel.pokemonMoveData)
                    } label: {
                        PoekmonDetailViewNavigationButton(titleText: "Show all movesets")
                    }
                    .padding(.top, 5)

                    Spacer()
                }
                .padding(EdgeInsets(top: 10, leading: 30, bottom: 5, trailing: 30))
                
                Divider()
                    .padding(.vertical, 10)
                
                //MARK: 플레이버 텍스트
                VStack {
                    Group {
                        Text("Flavor Texts")
                            .font(.title2)
                            .fontWeight(.black)
                        
                        Rectangle()
                            .frame(width: 20, height: 3)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    //기술 리스트
                    NavigationLink {
                        PokemonDetailFlavorTextView()
                    } label: {
                        PoekmonDetailViewNavigationButton(titleText: "Show Flavor Text")
                    }
                    .padding(.top, 5)
                    
                    Spacer()
                }
                .padding(EdgeInsets(top: 5, leading: 30, bottom: 120, trailing: 30))
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
            if viewModel.pokemonMoveData.isEmpty {
                await viewModel.fetch(urlString: endpoint)
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

//MARK: NavigationLink 회색 버튼
struct PoekmonDetailViewNavigationButton: View {
    
    let titleText: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10.0)
            .foregroundStyle(Color("pokeBrightGray"))
            .overlay {
                HStack {
                    Text("\(titleText)")
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .padding()
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12))
                        .padding(.trailing, 12)
                }
                .foregroundStyle(Color.black)
                .fontWeight(.bold)
            }
            .frame(height: 50)
    }
    
}

#Preview {
    NavigationStack {
        PokemonDetailView(pokeData: PokemonListObject(name: "pikachu", url: "https://pokeapi.co/api/v2/pokemon/25/"),
                                    endpoint: "https://pokeapi.co/api/v2/pokemon/25/")
    }
}
