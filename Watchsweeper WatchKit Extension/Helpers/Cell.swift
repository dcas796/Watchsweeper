//
//  Cell.swift
//  Watchsweeper WatchKit Extension
//
//  Created by Daniel Ortega on 9/4/22.
//

import Foundation
import SwiftUI

class Cell: ObservableObject {
    /// The row of the cell on the board
    var row: Int

    /// The column of the cell on the board
    var column: Int

    /// Current state of the cell
    @Published var status: Status

    /// Whether or not the cell has been opened/touched
    @Published var isOpened: Bool

    /// Whether or not the cell has been flagged
    @Published var isFlagged: Bool

    init(row: Int, column: Int) {
        self.row = row
        self.column = column
        self.status = .normal
        self.isOpened = false
        self.isFlagged = false
    }
    
    /// Get the image associated to the status of the cell
    var image: Image {
        if !isOpened && isFlagged {
            return Image("Cell_Flag")
        }
        
        guard isOpened else {
            return Image("Cell_Normal")
        }
        
        switch status {
        case .normal:
            return Image("Cell_Normal")
        case .bomb:
            return Image("Cell_Bomb")
        case .exposed(let number):
            if number == 0 {
                return Image("Cell_Empty")
            }
            
            guard -1 < number && number < 9 else {
                print("Warning: number out of bounds: \(number)")
                return Image("Cell_Empty")
            }
            
            return Image("Cell_\(number)")
        }
    }
}

extension Cell {
    /// Denoting the different states a square can be in
    enum Status: Equatable {
        /// The square is open and not touching anything
        case normal

        /// The square has been opened and touching n bombs
        /// value 1: - The number of bombs the square is touching. 0 for none.
        case exposed(Int)

        /// There is a bomb in the square
        case bomb
    }
}
