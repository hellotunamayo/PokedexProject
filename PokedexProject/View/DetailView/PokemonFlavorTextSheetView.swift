//
//  PokemonFlavorTextSheetView.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/29/24.
//

import SwiftUI

struct PokemonFlavorTextSheetView: View {
    
    @State private var showingFlavorText: [FlavorText] = []
    @Binding var locale: Locale?
    
    let flavorText: [FlavorText]
    
    var body: some View {
        ScrollView {
            ForEach(showingFlavorText) { text in
                Text(text.version.name)
                Text(getEmptySpaceTrimmed(string: text.flavorText))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .onAppear {
            getFlavorTextByLocale()
        }
        .onDisappear {
            locale = nil
        }
    }
    
    func getFlavorTextByLocale() {
        switch locale {
            case .en:
                showingFlavorText = flavorText.filter { $0.language.name == "en" }
            case .ko:
                showingFlavorText = flavorText.filter { $0.language.name == "ko" }
            case .jp:
                showingFlavorText = flavorText.filter { $0.language.name == "ja" }
            case .cn:
                showingFlavorText = flavorText.filter { $0.language.name == "zh-Hant" }
            case .de:
                showingFlavorText = flavorText.filter { $0.language.name == "de" }
            case .none:
                showingFlavorText = flavorText.filter { $0.language.name == "en" }
        }
    }
    
    func getEmptySpaceTrimmed(string: String) -> String {
        let setString = string.replacingOccurrences(of: "\n", with: " ")
        return setString
    }
}

#Preview {
    PokemonFlavorTextSheetView(locale: .constant(.jp), flavorText: [FlavorText(flavorText: "test string", language: FlavorTextLanguage(name: "ja", url: ""), version: FlavorTextVersion(name: "red", url: ""))])
}
