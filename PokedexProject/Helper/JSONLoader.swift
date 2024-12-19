//
//  JSONLoader.swift
//  PokedexProject
//
//  Created by 홍진표 on 12/18/24.
//

import Foundation

enum MockAPODLoaderError: Error {
    case unknownFile
    case dataConvertFail
    case notJSON
    case decodeFail
}

class JSONLoader {
    
    // MARK: - Mock Data Load FLOW
    /// `1. 파일 URL 얻어오기 -> 2. 파일 데이터를 Data 형식으로 읽기 -> 3. JSON 데이터인지 판별 -> 4. 지정 타입으로의 변환`
    static func load<T: Decodable>(dataType: T.Type, fileName: String) -> T? {
        
        do {
            let file: URL = try getFileURL(from: fileName)
            let data: Data = try getData(from: file)
            
            try validateJSONData(from: data)
            
            let decodedData: T = try decodeData(from: data, to: dataType)
            
            return decodedData
        } catch {
            loggingError(error: error)
            return nil
        }
    }
    
    /// `1. 파일 URL 얻어오기`
    private static func getFileURL(from fileName: String) throws -> URL {
        
        guard let filePath: String = Bundle(for: self).path(forResource: fileName, ofType: "json") else {
            throw MockAPODLoaderError.unknownFile
        }
        
        return URL(filePath: filePath)
    }
    
    /// `2. 파일 데이터를 Data 형식으로 읽기`
    private static func getData(from file: URL) throws -> Data {
        
        guard let data: Data = try? Data(contentsOf: file) else {
            throw MockAPODLoaderError.dataConvertFail
        }
        
        return data
    }
    
    /// `3. JSON 데이터인지 판별`
    private static func validateJSONData(from data: Data) throws -> Void {
        
        guard let _ = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) else {
            throw MockAPODLoaderError.notJSON
        }
    }
    
    /// `4. 지정 타입으로의 변환`
    private static func decodeData<T: Decodable>(from data: Data, to type: T.Type) throws -> T {
        
        guard let decodedData: T = try? JSONDecoder().decode(T.self, from: data) else {
            throw MockAPODLoaderError.decodeFail
        }
        
        return decodedData
    }
    
    static func getDataFromFileURL(fileName: String) -> Data? {
        
        do {
            let file: URL = try getFileURL(from: fileName)
            let data: Data = try getData(from: file)
            
            return data
        } catch {
            loggingError(error: error)
            return nil
        }
    }
    
    private static func loggingError(error: Error) -> Void {
        
        switch error {
        case MockAPODLoaderError.unknownFile:
            print("***** [unknownFile]: Could not find the file *****")
        case MockAPODLoaderError.dataConvertFail:
            print("***** [dataConvertFail]: Failed to convert the file content to data *****")
        case MockAPODLoaderError.notJSON:
            print("***** [notJSON]: The file data is not in JSON format *****")
        case MockAPODLoaderError.decodeFail:
            print("***** [decodeFail]: Failed to decode the JSON data *****")
        default:
            print("***** Unknown error: \(error.localizedDescription) *****")
        }
    }
}
