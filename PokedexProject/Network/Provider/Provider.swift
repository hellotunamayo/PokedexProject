//
//  Provider.swift
//  PokedexProject
//
//  Created by 홍진표 on 12/18/24.
//

import Foundation

protocol Provider: Sendable {
    func request<R, E>(with endpoint: E) async throws -> R where R: Decodable, E: RequestResponsable, E.Response == R
}
