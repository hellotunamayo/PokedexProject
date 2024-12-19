//
//  HttpError.swift
//  PokedexProject
//
//  Created by jinwoong Kim on 4/28/24.
//

import Foundation

enum HttpError: LocalizedError {
    case unknownError
    case httpStatusError(StatusError)
    case componentsError
    case urlRequestError(Error)
    case parsingError(Error)
    case emptyData
    case decodingError
    case toDictionaryError
    
    var errorDescription: String? {
        switch self {
        case .unknownError: return "알 수 없는 에러입니다."
        case .httpStatusError(let httpStatusError): return httpStatusError.errorDescription
        case .componentsError: return "components 생성 에러가 발생했습니다."
        case .urlRequestError: return "URL Request 관련 에러가 발생했습니다."
        case .parsingError: return "데이터 Parsing 중 에러가 발생했습니다."
        case .emptyData: return "Data가 비어 있습니다."
        case .decodingError: return "Decoding 에러가 발생했습니다."
        case .toDictionaryError: return "JSON convert to Foundation object 에러가 발생했습니다."
        }
    }
    
    // MARK: - HTTP 상태 에러 정의
    enum StatusError: LocalizedError {
        case clientError(ClientError)
        case serverError(ServerError)
        
        var errorDescription: String? {
            switch self {
            case .clientError(let clientError): return clientError.errorDescription
            case .serverError(let serverError): return serverError.errorDescription
            }
        }
        
        enum ClientError: Int, LocalizedError {
            case badRequest = 400
            case unauthorized = 401
            case forbidden = 403
            case notFound = 404
            
            var errorDescription: String? {
                switch self {
                case .badRequest: return "\(rawValue): Bad Request"
                case .unauthorized: return "\(rawValue): Unauthorized"
                case .forbidden: return "\(rawValue): Forbidden"
                case .notFound: return "\(rawValue): Not Found"
                }
            }
        }
        
        enum ServerError: Int, LocalizedError {
            case internalServerError = 500
            case notImplemented = 501
            case serviceUnavailable = 503
            
            var errorDescription: String? {
                switch self {
                case .internalServerError: return "\(rawValue): Internal Server Error"
                case .notImplemented: return "\(rawValue): Not Implemented"
                case .serviceUnavailable: return "\(rawValue): Service Unavailable"
                }
            }
        }
    }
}
