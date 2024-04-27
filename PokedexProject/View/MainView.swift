//
//  MainView.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/26/24.
//

import SwiftUI

struct MainView: View {
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
            
            SearchView()
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
