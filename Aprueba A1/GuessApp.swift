//
//  GuessApp.swift
//  Guess
//
//  Created by joan Barrull on 29/03/2025.
//

import SwiftUI

@main
struct GuessApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                FlashCardView()
               
                    .tabItem {
                        Label("Practice", systemImage: "square.and.pencil")
                    }
                
               
                    SearchView()
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                
                //SettingsView()
                ContentView3()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape")
                    }
            }
        }
    }
}


