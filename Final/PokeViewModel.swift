//
//  PokeViewModel.swift
//  Final
//
//  Created by DOWNING, AYDEN T. on 5/5/25.
//

import SwiftUI

class PokeViewModel: ObservableObject {
    @Published var randomPokemon: [PokemonEntry] = []
    @Published var types: [String] = []
    @Published var selectedType: String = ""
    @Published var typeBasedPokemon: [PokemonEntry] = []
    @Published var favorites: [PokemonEntry] = []

    func addToFavorites(_ pokemon: PokemonEntry) {
        if !favorites.contains(pokemon) {
            favorites.append(pokemon)
        }
    }

    func fetchRandomPokemon() {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=1000") else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(PokemonListResponse.self, from: data)
                    let random3 = Array(decoded.results.shuffled().prefix(3))
                    DispatchQueue.main.async {
                        self.randomPokemon = random3
                    }
                } catch {
                    print("Decode error:", error)
                }
            }
        }.resume()
    }

    func fetchTypes() {
        guard let url = URL(string: "https://pokeapi.co/api/v2/type") else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(PokemonListResponse.self, from: data)
                    let typeNames = decoded.results.map { $0.name }
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

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    guard let pokemonList = json?["pokemon"] as? [[String: Any]] else { return }

                    let entries: [PokemonEntry] = pokemonList.compactMap {
                        if let pokemonInfo = $0["pokemon"] as? [String: String],
                        let name = pokemonInfo["name"],
                        let url = pokemonInfo["url"] {
                            return PokemonEntry(name: name, url: url)
                        }
                        return nil
                    }

                    let random3 = Array(entries.shuffled().prefix(3))

                    DispatchQueue.main.async {
                        self.typeBasedPokemon = random3
                    }
                } catch {
                    print("Type-based decode error:", error)
                }
            }
        }.resume()
    }
}
