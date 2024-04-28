//
//  MediaType.swift
//  PokedexProject
//
//  Created by jinwoong Kim on 4/28/24.
//

import Foundation

enum MIMEType {
    case json
    
    var headerValue: String {
        switch self {
            case .json:
                return "application/json"
        }
    }
}
