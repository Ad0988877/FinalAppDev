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
        VStack {
            Text(viewModel.Pokemon)
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()
            
            Button("Get random Pokemon") {
                viewModel.fetchPokemon()
            }.border(Color.blue,)
                .foregroundStyle(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(20)
        }
        .padding()
        .onAppear {
            viewModel.fetchPokemon()
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
        }
    }
}


#Preview {
    ContentView()
}
