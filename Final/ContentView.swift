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
        TabView {
            VStack(spacing: 20) {
                Text("Random Pokémon:")

                ForEach(viewModel.randomPokemon, id: \.self) { entry in
                    Button(action: {
                        viewModel.addToFavorites(entry)
                    }) {
                        HStack {
                            if let imageUrl = entry.imageUrl {
                                AsyncImage(url: imageUrl) { image in
                                    image.resizable()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                            Text(entry.name.capitalized)
                                .padding()
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    }
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

                if !viewModel.typeBasedPokemon.isEmpty {
                    Text("Type-Based Pokémon: \(viewModel.selectedType.capitalized)")
                    ForEach(viewModel.typeBasedPokemon, id: \.self) { entry in
                        Button(action: {
                            viewModel.addToFavorites(entry)
                        }) {
                            HStack {
                                if let imageUrl = entry.imageUrl {
                                    AsyncImage(url: imageUrl) { image in
                                        image.resizable()
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                    } placeholder: {
                                        ProgressView()
                                    }
                                }
                                Text(entry.name.capitalized)
                                    .padding()
                            }
                            .frame(maxWidth: .infinity)
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(10)
                        }
                    }
                }
            }
            .padding()
            .tabItem {
                Label("Home", systemImage: "house")
            }

            FavoritesView(viewModel: viewModel)
                .tabItem {
                    Label("Favorites", systemImage: "star")
                }
        }
        .onAppear {
            viewModel.fetchTypes()
            viewModel.fetchRandomPokemon()
        }
    }
}

