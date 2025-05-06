//
//  PokeViewModel.swift
//  Final
//
//  Created by DOWNING, AYDEN T. on 5/5/25.
//

import SwiftUI
import Foundation

class PokeViewModel: ObservableObject {
    @Published var Pokemon: String = ""
    
    func fetchPokemon(){
        guard let url = URL(string: "https://pokeapi.co/api/v2")else {
            print( "Invalid URL")
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data{
                do{
                    let decodedResponse = try JSONDecoder().decode(PokeResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.Pokemon = decodedResponse.name.pokemon
                    }
                }catch{
                    print("Decoding Error: \(error)")
                }
            }else if let error = error{
                print("HTTP request failed: \(error)")
            }
        }.resume()
    }
}
class PokeViewModel: ObservableObject {
    @Published var randomPokemonNames: [String] = []
    @Published var types: [String] = []
    @Published var selectedType: String = ""
    @Published var typeBasedPokemonNames: [String] = []

    func fetchRandomPokemon() {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=1000") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(PokemonListResponse.self, from: data)
                    let allPokemon = decoded.results
                    let random3 = allPokemon.shuffled().prefix(3).map { $0.name }

                    DispatchQueue.main.async {
                        self.randomPokemonNames = random3
                    }
                } catch {
                    print("Decode error:", error)
                }
            }
        }.resume()
    }

    func fetchTypes() {
        guard let url = URL(string: "https://pokeapi.co/api/v2/type") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode([String: [PokemonEntry]].self, from: data)
                    let typeNames = decoded["results"]?.map { $0.name } ?? []

                    DispatchQueue.main.async {
                        self.types = typeNames
                    }
                } catch {
                    print("Type decode error:", error)
                }
            }
        }.resume()
    }

    func fetchPokemonByType(_ type: String) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/type/\(type)") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode([String: Any].self, from: data)
                    guard let pokemonList = decoded["pokemon"] as? [[String: Any]] else { return }
                    let names = pokemonList.compactMap { ($0["pokemon"] as? [String: String])?["name"] }
                    let random3 = names.shuffled().prefix(3)

                    DispatchQueue.main.async {
                        self.typeBasedPokemonNames = Array(random3)
                    }
                } catch {
                    print("Type-based decode error:", error)
                }
            }
        }.resume()
    }
}