//
//  URLSessionable.swift
//  PokedexProject
//
//  Created by 홍진표 on 12/18/24.
//

import Foundation

protocol URLSessionable: Sendable {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionable { }
