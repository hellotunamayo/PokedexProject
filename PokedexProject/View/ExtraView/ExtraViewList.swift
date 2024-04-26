//
//  ExtraViewList.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/26/24.
//

import SwiftUI

struct ExtraViewList: View {
    
    @State private var copyrightText: String = """
Pokémon is a trademark and copyright of Nintendo Inc., Game Freak, and Creatures. This application, including but not limited to its design, images, and information, is provided for informational purposes only and is not affiliated with or endorsed by Nintendo Inc., Game Freak, or Creatures. All Pokémon-related content used in this application is used under fair use principles for educational and informational purposes only. Pokémon and Pokémon character names are trademarks of Nintendo Inc.
"""
    
    var body: some View {
        NavigationStack {
            HStack {
                Image("pokedexIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24, alignment: .center)
                
                Text("PokeDex Project")
                    .font(Font.custom("Silkscreen-Regular", size: 24))
            }
            
            List {
                Section("Legal Information") {
                    NavigationLink("Copyright Notice") {
                        ScrollView {
                            VStack {
                                Text("Copyright Notice")
                                    .fontWeight(.bold)
                                    .font(.title)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.bottom, 10)
                                Text(copyrightText)
                                    .lineLimit(nil)
                                    .lineSpacing(6.0)
                            }
                            .padding()
                        }
                    }
                }
                
                Section("Software Information") {
                    NavigationLink("Show on GitHub") {
                        GitHubView()
                    }
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown Build")")
                    }
                    
                }
            }
        }
    }
    
}

#Preview {
    ExtraViewList()
}
