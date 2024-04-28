//
//  PokemonAPIService.swift
//  PokedexProject
//
//  Created by jinwoong Kim on 4/28/24.
//

import Foundation

final class PokemonAPIService: APIService {
    var session: URLSession
    
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
