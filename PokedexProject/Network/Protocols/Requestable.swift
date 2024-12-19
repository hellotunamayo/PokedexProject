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
    var queryParams: Encodable? { get }
    var bodyParams: Encodable? { get }
    var headers: [HttpHeader]? { get }
    var sampleData: Data? { get }
}

//  HTTP 요청을 구성하는 데 필요한 URL과 URLRequest 객체를 만듦
extension Requestable {
    func makeURL() throws -> URL {
        
        //  baseURL+path
        let fullPath: String = baseURL + path
        
        guard var urlComponents: URLComponents = URLComponents(string: fullPath) else {
            throw HttpError.componentsError
        }
        
        //  (baseURL+path)+queryParams
        var urlQueryItems: [URLQueryItem] = []
        
        //  Encodable object (JSON) -> Foundation object
        guard let queryParams: [String : Any] = try queryParams?.toDictionary() else { throw HttpError.toDictionaryError }
        
        //  Dictionary 타입의 Foundation object인 queryParams를 하나씩 추출해서 urlQueryItems에 추가
        queryParams.forEach { key, value in
            urlQueryItems.append(URLQueryItem(name: key, value: "\(value)"))
        }
        
        urlComponents.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        
        guard let url: URL = urlComponents.url else { throw HttpError.componentsError }
        
        return url
    }
    
    func getURLRequest() throws -> URLRequest {
        
        let url: URL = try makeURL()
        var urlRequest: URLRequest = URLRequest(url: url)
        
        //  HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        //  HTTP Header
        if (headers != nil) {
            headers?.forEach({ urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) })
        }
        
        //  HTTP Body
        if (bodyParams != nil) {
            guard let bodyParams: [String : Any] = try bodyParams?.toDictionary() else { throw HttpError.toDictionaryError }
            
            if (!bodyParams.isEmpty) {
                //  Dictionary 타입의 object를 JSON 형식으로 변환 후, httpBody에 저장하여 서버에 전송할 데이터 삽입
                urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: bodyParams)
            }
        }
        
        return urlRequest
    }
}

//  객체를 Codable로 인코딩하여 JSON 형식의 Data로 변환한 후, 이를 다시 [String, Any]로 변환
extension Encodable {
    func toDictionary() throws -> [String : Any] {
        
        let data: Data = try JSONEncoder().encode(self)
        guard let dictionary: [String : Any] = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
            throw NSError()
        }
        
        return dictionary
    }
}
