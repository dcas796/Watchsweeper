//
//  GameSettings.swift
//  Watchsweeper WatchKit Extension
//
//  Created by Daniel Ortega on 9/4/22.
//

import WatchKit

class GameSettings: ObservableObject {
    /// The number of rows on the board
    @Published var numberOfRows = 10

    /// The number of columns on the board
    @Published var numberOfColumns = 10

    /// The total number of bombs
    @Published var numberOfBombs = 10

    /// The size each square should be based on the width of the screen
    var squareSize: CGFloat {
        WKInterfaceDevice.current().screenBounds.width / CGFloat(numberOfColumns)
    }
}
