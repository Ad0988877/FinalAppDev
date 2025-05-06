//
//  PokeResponse.swift
//  Final
//
//  Created by DOWNING, AYDEN T. on 5/5/25.
//
import SwiftUI
import Foundation

struct PokemonListResponse: Codable {
    let results: [PokemonEntry]
}

struct PokemonEntry: Codable, Hashable {
    let name: String
    let url: String

    var id: Int? {
        if let last = url.split(separator: "/").last,
        let id = Int(last) {
            return id
        }
        return nil
    }

    var imageUrl: URL? {
        guard let id = id else { return nil }
        return URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png")
    }
}
