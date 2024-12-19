//
//  APIService.swift
//  PokedexProject
//
//  Created by jinwoong Kim on 4/28/24.
//

import Foundation

protocol APIService: Provider, Sendable {
//    @MainActor var session: URLSessionable { get }
    var session: URLSessionable { get }
}

extension APIService {
//    @MainActor
    func request<R, E>(with endpoint: E) async throws -> R where R : Decodable, R == E.Response, E : Requestable, E : Responsable {
        let urlRequest: URLRequest = try endpoint.getURLRequest()
        let (data, response): (Data, URLResponse) = try await session.data(for: urlRequest)
        
        try self.checkError(with: response)
        
        return try self.decode(data: data)
    }
    
    // MARK: - PRIVATE Methods
    func checkError(with response: URLResponse) throws -> Void {
        
        guard let response: HTTPURLResponse = response as? HTTPURLResponse else { throw HttpError.unknownError }
        
        guard (200..<300) ~= response.statusCode else {
            switch response.statusCode {
            case (400..<500):   //  Client Error 처리
                throw HttpError.httpStatusError(.clientError(HttpError.StatusError.ClientError(rawValue: response.statusCode)!))
            case (500..<600):   //  Server Error 처리
                throw HttpError.httpStatusError(.serverError(HttpError.StatusError.ServerError(rawValue: response.statusCode)!))
            default:
                throw HttpError.unknownError
            }
        }
    }
    
    private func decode<T>(data: Data) throws -> T where T: Decodable {
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw HttpError.emptyData
        }
    }
}
