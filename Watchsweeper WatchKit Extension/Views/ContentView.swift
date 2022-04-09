//
//  ContentView.swift
//  Watchsweeper WatchKit Extension
//
//  Created by Daniel Ortega on 8/4/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var game: Game
    
    var body: some View {
        BoardView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Game())
    }
}

