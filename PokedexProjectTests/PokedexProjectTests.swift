//
//  PokedexProjectTests.swift
//  PokedexProjectTests
//
//  Created by 홍진표 on 12/19/24.
//

import Testing
import Foundation

@testable import PokedexProject

struct PokedexProjectTests {
    
    var sut: Provider?
    
    init() {
        let configuration: URLSessionConfiguration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        
        let urlSession: URLSession = URLSession(configuration: configuration)
        
        sut = PokemonAPIService(session: urlSession)
    }

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
    
    @Test("EntryUseCase-Success")
    func fetchEntryUseCaseWhenStatusCode200() async throws -> Void {
        
        //  Given
        let endpoint: Endpoint<PokemonList> = Endpoint(baseURL: "https://pokeapi.co/",
                                                       path: "api/v2/pokemon",
                                                       method: .get,
                                                       queryParams: PokemonListObjectDTO(limit: 10, offset: 0),
                                                       sampleData: JSONLoader.getDataFromFileURL(fileName: "MockPokemonListData"))
        
        guard let data: Data = JSONLoader.getDataFromFileURL(fileName: "MockPokemonListData"),
              let response: PokemonList = try? JSONDecoder().decode(PokemonList.self, from: data) else {
            throw HttpError.emptyData
        }
        
        MockURLProtocol.requestHandler = { request in
            /// `성공:` callback으로 넘겨줄 Response
            let successResponse: HTTPURLResponse? = HTTPURLResponse(url: try! endpoint.makeURL(),
                                                                    statusCode: 200,
                                                                    httpVersion: nil,
                                                                    headerFields: nil)
            
            return (endpoint.sampleData, successResponse, nil)
        }
        
        //  When
        let pokemonLists: [PokemonListObject]? = try await sut?.request(with: endpoint).results
        
        //  Then
        print("***** 테스트 성공 *****")
        print("pokemonLists: \(pokemonLists)")
        
        #expect(pokemonLists?.first?.name == response.results.first?.name)
    }
    
    @Test("EntryUseCase-Failure")
    func fetchEntryUseCaseWhenStatusCodeNot200() async throws {
        
        //  Given
        let endpoint: Endpoint<PokemonList> = Endpoint(baseURL: "https://pokeapi.co/",
                                                       path: "api/v2/pokemon",
                                                       method: .get,
                                                       queryParams: PokemonListObjectDTO(limit: 10, offset: 0),
                                                       sampleData: JSONLoader.getDataFromFileURL(fileName: "MockPokemonListData"))
        
        MockURLProtocol.requestHandler = { request in
            /// `실패:` callback으로 넘겨줄 Response
            let failureResponse: HTTPURLResponse? = HTTPURLResponse(url: try! endpoint.makeURL(),
                                                                    statusCode: 400,
                                                                    httpVersion: nil,
                                                                    headerFields: nil)
            
            return (nil, failureResponse, nil)
        }
        
        do {
            //  When
            try await sut?.request(with: endpoint).results
        } catch {
            //  Then
            print("***** 테스트 실패 *****")
            print("error: \(error.localizedDescription)")
            #expect(error.localizedDescription == HttpError.StatusError.ClientError.badRequest.errorDescription)
        }
    }

}
