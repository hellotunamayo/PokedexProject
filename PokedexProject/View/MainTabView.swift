//
//  MainTabView.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/21/24.
//

import SwiftUI

struct MainTabView: View {
    
    var body: some View {
        NavigationStack {
            TabView {
                EntryView(viewModel: EntryViewModel(limit: 650, offset: 0),
                          startFrom: 0)
                    .tabItem {
                        Label(
                            title: {
                                Text("1-649")
                            },
                            icon: {
                                Image(systemName: "circle.bottomhalf.filled")
                            }
                        )
                    }
                
                EntryView(viewModel: EntryViewModel(limit: 375, offset: 650),
                          startFrom: 650)
                    .tabItem {
                        Label(
                            title: {
                                Text("650-1025")
                            },
                            icon: {
                                Image(systemName: "circle.bottomhalf.filled")
                            }
                        )
                    }
                
                Text("Under development")
                    .tabItem {
                        Label(
                            title: {
                                Text("Search")
                            },
                            icon: {
                                Image(systemName: "magnifyingglass.circle")
                            }
                        )
                    }
            }
        }
    }
    
}

#Preview {
    MainTabView()
}
