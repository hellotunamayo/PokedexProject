//
//  APIService.swift
//  PokedexProject
//
//  Created by jinwoong Kim on 4/28/24.
//

import Foundation

protocol APIService: Sendable {
    @MainActor var session: URLSession { get }
}

extension APIService {
    @MainActor
    func request<R: Decodable, E: Requestable & Responsable>(
        with endpoint: E
    ) async throws -> R where E.Response == R {
        let request = try endpoint.buildRequest()
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw HttpError.badResponse
        }
        guard httpResponse.statusCode == 200 else {
            throw HttpError.errorWith(code: httpResponse.statusCode, data: data)
        }
        
        return try decode(data: data)
    }
    
    private func decode<T: Decodable>(data: Data) throws -> T {
        try JSONDecoder().decode(T.self, from: data)
    }
}
