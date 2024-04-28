//
//  HttpError.swift
//  PokedexProject
//
//  Created by jinwoong Kim on 4/28/24.
//

import Foundation

enum HttpError: Error {
    case invalidRequest
    case badResponse
    case errorWith(code: Int, data: Data)
    case invalidURL
}
