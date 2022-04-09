//
//  WatchsweeperApp.swift
//  Watchsweeper WatchKit Extension
//
//  Created by Daniel Ortega on 8/4/22.
//

import SwiftUI

@main
struct WatchsweeperApp: App {
    var gameSettings = GameSettings()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .environmentObject(Game(from: gameSettings))
            }
        }
    }
}
