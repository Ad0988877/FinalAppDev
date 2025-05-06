//
//  ContentView.swift
//  Final
//
//  Created by DOWNING, AYDEN T. on 5/5/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PokeViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("Random Pokémon:")
            ForEach(viewModel.randomPokemonNames, id: \.self) { name in
                Text(name.capitalized)
            }

            Button("Get 3 Random Pokémon") {
                viewModel.fetchRandomPokemon()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            Picker("Select Type", selection: $viewModel.selectedType) {
                ForEach(viewModel.types, id: \.self) { type in
                    Text(type.capitalized)
                }
            }
            .onChange(of: viewModel.selectedType) { newType in
                viewModel.fetchPokemonByType(newType)
            }
            .padding()

            if !viewModel.typeBasedPokemonNames.isEmpty {
                Text("Type-Based Pokémon: \(viewModel.selectedType.capitalized)")
                ForEach(viewModel.typeBasedPokemonNames, id: \.self) { name in
                    Text(name.capitalized)
                }
            }
        }
        .onAppear {
            viewModel.fetchTypes()
            viewModel.fetchRandomPokemon()
        }
        .padding()
    }
}



#Preview {
    ContentView()
}
            //add this later with a starred pokemon button
//            TabView {
//                HomeView()
//                    .tabItem {
//                        Label("Home", systemImage: "person")
//                    }
//                Colors()
//                    .tabItem {
//                        Label("Colors", systemImage: "book")
//                    }
//                
//                HeroSelection()
//                    .tabItem {
//                        Label("Characters", systemImage: "star")
//}
//}