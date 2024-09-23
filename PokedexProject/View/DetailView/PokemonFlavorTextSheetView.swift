//
//  PokemonFlavorTextSheetView.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/29/24.
//

import SwiftUI

struct PokemonFlavorTextSheetView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var showingFlavorText: [FlavorText] = []
    @Binding var locale: Locale?
    
    let flavorText: [FlavorText]
    let typeColor: UIColor
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(showingFlavorText) { text in
                    Group {
                        Text(text.version.name.capitalized)
                            .fontWeight(.bold)
                            .font(.caption)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .foregroundStyle(Color.white)
                            .background(Color(typeColor))
                            .clipShape(Capsule())
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .offset(x: -3)
                        
                        Text(getEmptySpaceTrimmed(string: text.flavorText.convertFullwidthToHalfwidth()))
                            .lineSpacing(locale == .jp ? 9 : 7)
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 5)
                    }
                    .padding(.horizontal)
                    
                    Divider()
                        .padding(.vertical, 10)
                }
            }
            .toolbar(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text("Close")
                    })
                }
            }
            .onAppear {
                getFlavorTextByLocale()
            }
            .onDisappear {
                locale = nil
            }
            .overlay {
                if showingFlavorText.isEmpty {
                    VStack {
                        Image("emptyViewCharacterImage")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 200, maxHeight: 200)
                            .padding(.bottom, -10)
                        
                        Text("There is no flavor text\nin this language.")
                            .fontWeight(.bold)
                            .font(.title2)
                            .frame(minWidth: 250, maxWidth: .infinity)
                    }
                    .offset(y: -50)
                }
            }
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
    PokemonFlavorTextSheetView(locale: .constant(.jp), flavorText: [FlavorText(flavorText: "うまれたときから　せなかに ふしぎな　タネが　うえてあって からだと　ともに　そだつという。", language: FlavorTextLanguage(name: "ja", url: ""), version: FlavorTextVersion(name: "Lets-Go-Pikachu", url: ""))], typeColor: UIColor.systemGreen)
//    PokemonFlavorTextSheetView(locale: .constant(.jp), flavorText: [], typeColor: UIColor.systemGreen)
}
