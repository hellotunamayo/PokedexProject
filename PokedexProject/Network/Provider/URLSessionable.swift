//
//  URLSessionable.swift
//  PokedexProject
//
//  Created by 홍진표 on 12/19/24.
//

import Foundation

protocol URLSessionable {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionable { }
