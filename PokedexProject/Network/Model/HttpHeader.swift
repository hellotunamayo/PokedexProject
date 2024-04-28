//
//  HttpHeader.swift
//  PokedexProject
//
//  Created by jinwoong Kim on 4/28/24.
//

import Foundation

enum HttpHeader {
    case accept(MIMEType)
    case contentType(MIMEType)
    
    var key: String {
        switch self {
            case .accept:
                return "Accept"
            case .contentType:
                return "Content-Type"
        }
    }
    
    var value: String {
        switch self {
            case let .accept(mimeType):
                return mimeType.headerValue
            case let .contentType(mimeType):
                return mimeType.headerValue
        }
    }
}
