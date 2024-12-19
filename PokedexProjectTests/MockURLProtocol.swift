//
//  MockURLProtocol.swift
//  PokedexProjectTests
//
//  Created by 홍진표 on 12/19/24.
//

import Foundation

//  URLProtocol은 Abstract Class로 protocol별 URL 데이터 load를 처리한다
//  URLProtocol은 URL Loading System에 대한 확장 지점을 제공하기 위해 subclass화 되도록 설계되었음
/// ref. https://developer.apple.com/kr/videos/play/wwdc2018/417/?time=499
class MockURLProtocol: URLProtocol {
    
    /// 1️⃣ request를 받아서 mock response를 넘겨주는 closure 생성
    static var requestHandler: ((URLRequest) throws -> (Data?, URLResponse?, (any Error)?))?
    
    /// Param으로 받는 request를 처리할 수 있는 프로토콜 타입인지 검사하는 메서드
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    /// Request를 canonical (표준)버전으로 반환하는데, 거의 param으로 받은 request를 그대로 반환
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        /// test case 별로 mock response를 생성하고, URLProtocolClient로 해당 response를 보내는 부분
        
        guard let handler: ((URLRequest) throws -> (Data?, URLResponse?, (any Error)?)) = MockURLProtocol.requestHandler else {
            fatalError("Handler is unavailable.")
        }
        
        do {
            /// 2️⃣ 받은 request를 args로 전달하며 handler를 호출하고,
            /// return되는 response와 data를 저장
            let (data, response, _): (Data?, URLResponse?, (any Error)?) = try handler(request)
            
            if let response: HTTPURLResponse = (response as? HTTPURLResponse) {
                /// 3️⃣ 저장한 response를 client에게 전달
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            if let data: Data = data {
                /// 4️⃣ 저장한 data를 client에게 전달
                client?.urlProtocol(self, didLoad: data)
            }
            
            /// 5️⃣ request가 완료되었음을 알림
            client?.urlProtocolDidFinishLoading(self)
        } catch  {
            /// 6️⃣ 만약 handler가 request를 받아서 에러가 발생한다면 발생한 에러를 알림
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
        /// request가 취소 or 완료되었을 때, 호출되는 부분
    }
}

