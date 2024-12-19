//
//  Provider.swift
//  PokedexProject
//
//  Created by 홍진표 on 12/19/24.
//

import Foundation

protocol Provider {
    func request<R, E>(with endpoint: E) async throws -> R where R: Decodable, E: RequestResponsable, E.Response == R
}
