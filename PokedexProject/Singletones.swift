//
//  Singletones.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/18/24.
//

import Foundation
import AVFoundation

class AudioSession {
    
    static let shared: AVAudioSession = AVAudioSession()
    private init() { }
    
}
