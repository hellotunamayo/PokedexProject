//
//  PokemonSpriteView.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/19/24.
//

import SwiftUI
import CoreMotion

struct PokemonSpriteView: View {
    
    @State private var roll: Double = 0.0
    @State private var pitch: Double = 0.0
    
    let motionManager: CMMotionManager = CMMotionManager()
    let imageUrl: URL
    let viewWidth: CGFloat
    var body: some View {
        AsyncImage(url: imageUrl) { image in
            ZStack {
                Rectangle()
                    .fill(Color(uiColor: UIColor(red: 213/255, green: 50/255, blue: 50/255, alpha: 0.3)))
                    .padding(.top, viewWidth / 2)
                image
                    .offset(x: roll * 10, y: pitch * 10 - 5)
                    .onAppear {
                        if motionManager.isDeviceMotionAvailable {
                            motionManager.deviceMotionUpdateInterval = 0.01
                            motionManager.startDeviceMotionUpdates(to: .main) { motion, error in
                                guard let motion = motion else { return }
                                roll = motion.attitude.roll
                                pitch = motion.attitude.pitch
                            }
                        }
                    }
            }
        } placeholder: {
            Rectangle()
                .foregroundStyle(Color.clear)
        }
        .frame(width: viewWidth, height: viewWidth, alignment: .center)
        .background(Color("detailViewSheetBackground"))
        .clipShape(.circle)
        .aspectRatio(contentMode: .fit)
    }
}
