//
//  Locale.swift
//  PokedexProject
//
//  Created by jinwoong Kim on 4/24/24.
//

import Foundation

enum Locale: String, Identifiable, CaseIterable {
    var id: Self { self }
    
    case ko
    case jp
    case cn
    case de
    case en
    
    var accessName: String {
        switch self {
            case .ko:
                return "ko"
            case .jp:
                return "ja-Hrkt"
            case .cn:
                return "zh-Hant"
            case .de:
                return "de"
            case .en:
                return "en"
        }
    }
}
