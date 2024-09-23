//
//  PokemonAPIService.swift
//  PokedexProject
//
//  Created by jinwoong Kim on 4/28/24.
//

import Foundation

actor PokemonAPIService: APIService, Sendable {
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
}

extension PokemonAPIService: EntryUseCase {
    func fetch(with urlString: String) async -> [PokemonListObject] {
        let endpoint: Endpoint<PokemonList> = Endpoint(urlString: urlString)
        do {
            let data = try await request(with: endpoint)
            return data.results
        } catch {
            debugPrint("‼️: ", error)
            return []
        }
    }
}

extension PokemonAPIService: PokemonDetailUseCase {
    func fetch(urlString: String) async -> PokemonDetailData? {
        let endpoint: Endpoint<PokemonDetailData> = Endpoint(urlString: urlString)
        do {
            return try await request(with: endpoint)
        } catch {
            debugPrint("‼️: ", error)
            return nil
        }
    }
    
    func fetchSpicies(urlString: String) async -> PokemonSpeciesData? {
        let endpoint: Endpoint<PokemonSpeciesData> = Endpoint(urlString: urlString)
        do {
            return try await request(with: endpoint)
        } catch {
            debugPrint("‼️: ", error)
            return nil
        }
    }
}
