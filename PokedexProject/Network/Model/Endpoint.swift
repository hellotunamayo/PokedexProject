//
//  Endpoint.swift
//  PokedexProject
//
//  Created by jinwoong Kim on 4/28/24.
//

import Foundation

struct Endpoint<R: Decodable>: Requestable, Responsable {
    typealias Response = R
    
    var baseURL: String
    var path: String
    var method: HttpMethod
    var headers: [HttpHeader]?
    var body: Data?
    
    
    init(
        baseURL: String,
        path: String,
        method: HttpMethod,
        headers: [HttpHeader]? = nil,
        body: Data? = nil
    ) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.headers = headers
        self.body = body
    }
    
    init(urlString: String) {
        self.baseURL = urlString
        self.path = ""
        self.method = .get
    }
}
