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
                Group {
                    EntryView()
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
                    
                    Text("Under development")
                        .tabItem {
                            Label(
                                title: {
                                    Text("650-1000")
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
    
}

#Preview {
    MainTabView()
}
