//
//  PokedexProjectApp.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/18/24.
//

import SwiftUI
import SwiftData

@main
struct PokedexProjectApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(for: FavoriteModel.self)
    }
}
