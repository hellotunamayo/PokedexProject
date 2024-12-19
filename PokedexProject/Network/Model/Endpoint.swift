//
//  Endpoint.swift
//  PokedexProject
//
//  Created by jinwoong Kim on 4/28/24.
//

import Foundation

protocol RequestResponsable: Requestable, Responsable { }

struct Endpoint<R>: RequestResponsable {
    typealias Response = R
    
    var baseURL: String
    var path: String
    var method: HttpMethod
    var queryParams: (any Encodable)?
    var bodyParams: (any Encodable)?
    var headers: [HttpHeader]?
    var sampleData: Data?
    
    init(baseURL: String,
         path: String = "",
         method: HttpMethod = .get,
         queryParams: (any Encodable)? = nil,
         bodyParams: (any Encodable)? = nil,
         headers: [HttpHeader]? = nil,
         sampleData: Data? = nil) {
        
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.queryParams = queryParams
        self.bodyParams = bodyParams
        self.headers = headers
        self.sampleData = sampleData
    }
}
