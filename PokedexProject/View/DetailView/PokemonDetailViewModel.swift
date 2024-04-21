//
//  PokemonDetailViewModel.swift
//  PokedexProject
//
//  Created by Minyoung Yoo on 4/18/24.
//

import Foundation
import Observation

@Observable
class PokemonDataViewModel {
    
    var pokemonData: PokemonDetailData?
    var pokemonSpeciesData: PokemonSpeciesData?
    
    var pokemonId: Int {
        pokemonData?.id ?? 1
    }
    
    @MainActor func fetch(urlString: String) async throws -> () {
        //fetch default data
        let url = urlString
        guard let url = URL(string: url) else { return }
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decodedData = try? JSONDecoder().decode(PokemonDetailData.self, from: data)
        pokemonData = decodedData
        
        //fetch spicies data
        let speciesURLString = "https://pokeapi.co/api/v2/pokemon-species/\(pokemonId)"
        try await fetchSpicies(urlString: speciesURLString)
    }
    
    func fetchSpicies(urlString: String) async throws -> () {
        guard let speciesURL = URL(string: urlString) else {
            return }
        let(data, _) = try await URLSession.shared.data(from: speciesURL)
        guard let decodedData = try? JSONDecoder().decode(PokemonSpeciesData.self, from: data) else {
            print("could not decode localized data")
            return
        }
        pokemonSpeciesData = decodedData
    }
    
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
