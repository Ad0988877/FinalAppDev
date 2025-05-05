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
