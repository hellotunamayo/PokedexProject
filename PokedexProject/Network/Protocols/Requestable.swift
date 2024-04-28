//
//  Requestable.swift
//  PokedexProject
//
//  Created by jinwoong Kim on 4/28/24.
//

import Foundation

protocol Requestable {
    var baseURL: String { get }
    var path: String { get }
    var method: HttpMethod { get }
    var headers: [HttpHeader]? { get }
    var body: Data? { get }
}

extension Requestable {
    private func url() throws -> URL {
        guard let url = URL(string: baseURL) else {
            throw URLError(.badURL)
        }
        return url.appending(path: path)
    }
    
    func buildRequest() throws -> URLRequest {
        let url = try url()
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        headers?.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        return request
    }
}
