//
//  PokemonDetailViewModel.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/18/24.
//

import Foundation
import SwiftUI

@Observable
final class PokemonDetailViewModel {
    private let apiService: some PokemonDetailUseCase = PokemonAPIService()
    private(set) var pokemonData: PokemonDetailData?
    private(set) var pokemonSpeciesData: PokemonSpeciesData?
    private(set) var pokemonMoveData: [PokemonMoveData] = []
    
    private var pokemonNames: [PokemonGlobalName] {
        pokemonSpeciesData?.names ?? []
    }
    
    private var pokemonGenera: [PokemonGenera] {
        pokemonSpeciesData?.genera ?? []
    }
    
    @MainActor
    func fetch(urlString: String) async -> () {
        let result = await apiService.fetch(urlString: urlString)
        pokemonData = result
        pokemonMoveData = result?.moves ?? []
        let speciesURLString = "https://pokeapi.co/api/v2/pokemon-species/\(result?.id ?? 1)"
        pokemonSpeciesData = await apiService.fetchSpicies(urlString: speciesURLString)
    }
    
    @MainActor
    func downloadFromURL(urlString: String) async throws -> URL {
        
        enum DownloadError: String, Error {
            case failedToUnwrap = "Failed to unwrap URL"
            case downloadError = "While downloading an error occurred"
        }
        
        guard let url = URL(string: urlString) else {
            print(DownloadError.failedToUnwrap.rawValue)
            throw DownloadError.failedToUnwrap
        }
        
        do {
            let fileManager = FileManager()
            let (responseURL, _) = try await URLSession.shared.download(from: url)
            let documentsURL = try FileManager.default.url(for: .documentDirectory,
                                                           in: .userDomainMask,
                                                           appropriateFor: nil,
                                                           create: false)
            let savedURL = documentsURL
                .appendingPathComponent("\(pokemonData?.name ?? "untitledpokemon").ogg")
            
            if fileManager.fileExists(atPath: responseURL.absoluteString) {
                return savedURL
            } else {
                try? FileManager.default.removeItem(at: savedURL)
                try FileManager.default.moveItem(at: responseURL, to: savedURL)
                print("\(responseURL) -> \(savedURL)")
                return savedURL
            }
        } catch {
            print("Download Error -> \(error)")
            print(DownloadError.downloadError.rawValue)
            throw DownloadError.downloadError
        }
    }
}

extension PokemonDetailViewModel {
    func retrieveLocalName(from locale: Locale) -> String? {
        pokemonNames
            .first { $0.language.name == locale.accessName }?
            .name
    }
    
    func retrieveLocalGenus(from locale: Locale) -> String? {
        pokemonGenera
            .first { $0.language.name == locale.accessName }?
            .genus
    }
}
