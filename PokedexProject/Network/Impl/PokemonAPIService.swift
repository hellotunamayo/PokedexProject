//
//  PokemonAPIService.swift
//  PokedexProject
//
//  Created by jinwoong Kim on 4/28/24.
//

import Foundation

final class PokemonAPIService: APIService {
    static let shared: PokemonAPIService = .init()
    let session: URLSessionable
    
    init(session: URLSessionable = URLSession.shared) {
        self.session = session
    }
}

extension PokemonAPIService: EntryUseCase {
    func fetch(with limit: Int, offset: Int) async -> [PokemonListObject] {
        //  데이터 전송 객체 생성
        let pokemonListObjectDTO: PokemonListObjectDTO = .init(limit: limit, offset: offset)
        
        // PokemonList 엔드포인트 생성
        let endpoint: Endpoint<PokemonList> = Endpoint(baseURL: "https://pokeapi.co/",
                                                       path: "api/v2/pokemon",
                                                       method: .get,
                                                       queryParams: pokemonListObjectDTO,
                                                       sampleData: JSONLoader.getDataFromFileURL(fileName: "MockPokemonListData"))
        
        do {
            //  생성된 endpoint를 통해 요청하고, PokemonList의 "results" 키의 값 (= [PokemonListObject])을 반환
            return try await PokemonAPIService.shared.request(with: endpoint).results
        } catch {
            debugPrint("‼️: ", error)
        }
        
        return []
    }
}

extension PokemonAPIService: PokemonDetailUseCase {
    
    func fetch(with pokemonListObject: PokemonListObject) async -> PokemonDetailData? {
        let baseURL: String = pokemonListObject.url.components(separatedBy: "/api/")[0] + "/"   //  "https://pokeapi.co/"
        let path: String = pokemonListObject.url.components(separatedBy: baseURL)[1]    //  "api/v2/pokemon/1/"
        let endpoint: Endpoint<PokemonDetailData> = Endpoint(baseURL: baseURL,
                                                             path: path,
                                                             method: .get,
                                                             queryParams: EmptyDTO())
        
        do {
            return try await request(with: endpoint)
        } catch {
            debugPrint("‼️: ", error)
            return nil
        }
    }
    
    func fetch_Spicies(with pokemonDetailData: PokemonDetailData) async -> PokemonSpeciesData? {
        
        let endpoint: Endpoint<PokemonSpeciesData> = Endpoint(baseURL: "https://pokeapi.co/",
                                                              path: "api/v2/pokemon-species/\(pokemonDetailData.id)",
                                                              method: .get,
                                                              queryParams: EmptyDTO())
        
        do {
            return try await request(with: endpoint)
        } catch {
            debugPrint("‼️: ", error)
            return nil
        }
    }
}
