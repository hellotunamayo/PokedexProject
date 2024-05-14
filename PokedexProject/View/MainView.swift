//
//  MainView.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/26/24.
//

import SwiftUI

struct MainView: View {
    @Environment(\.pokemonAPIService) private var service
    
    var body: some View {
        TabView {
            MainGridView()
                .tabItem {
                    Label(
                        title: {
                            Text("Pokedex")
                        },
                        icon: {
                            Image(systemName: "circle.circle.fill")
                        }
                    )
                }
            
            FavoriteView()
                .tabItem {
                    Label(
                        title: {
                            Text("Favorite")
                        },
                        icon: {
                            Image(systemName: "heart")
                        }
                    )
                }
            
            SearchView(viewModel: EntryViewModel(limit: 1100, offset: 0, service: service))
                .tabItem {
                    Label(
                        title: {
                            Text("Search")
                        },
                        icon: {
                            Image(systemName: "magnifyingglass")
                        }
                    )
                }
            
            ExtraViewList()
                .tabItem {
                    Label(
                        title: {
                            Text("Extras")
                        },
                        icon: {
                            Image(systemName: "line.3.horizontal")
                        }
                    )
                }
        }
    }
}

#Preview {
    MainView()
}
