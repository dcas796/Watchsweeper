//
//  Game.swift
//  Watchsweeper WatchKit Extension
//
//  Created by Daniel Ortega on 9/4/22.
//

import Foundation

class Game: ObservableObject {
    /// A 2D array of cells
    typealias Board = [[Cell]]
    
    /// The game settings
    @Published var settings: GameSettings
    
    /// The game board
    @Published var board: Board
    
    /// A boolean value that indicates whether the result is being shown
    @Published var showResult: Bool = false
    
    /// A boolean value that indicates whether the player has won or not
    @Published var isWon: Bool = false
    
    /// Create a new Game instance with the specified game settings
    init(from settings: GameSettings) {
        self.settings = settings
        self.board = Self.generateGameBoard(from: settings)
    }
    
    /// Create a new Game instance with the default game settings
    convenience init() {
        self.init(from: GameSettings())
    }
    
    
    /// Check if the player has won or not
    /// - Returns: A boolean value that indicates whether the player has won or not
    func hasPlayerWon() -> Bool {
        for row in 0..<settings.numberOfRows {
            for column in 0..<settings.numberOfColumns {
                //If board contains normal cell, it means game is still going on.
                if board[row][column].status == .normal {
                    return false
                }
            }
        }
        return true
    }
    
    /// Reveal the state of the given cell
    /// - Parameter cell: The cell to be revealed
    func click(on cell: Cell) {
        // Skip if already exposed
        if case .exposed(_) = cell.status {
            return
        }
        
        // Skip if flagged
        guard !cell.isFlagged else {
            return
        }
        
        // Check cell is not a bomb
        if cell.status == .bomb {
            cell.isOpened = true
            showResult = true
            isWon = false
        } else {
            reveal(for: cell)
        }
        
        // Check if the player has won
        if hasPlayerWon() {
            showResult = true
            isWon = true
        }
        
        self.objectWillChange.send()
    }
    
    
    /// Toggle the flag on the given cell
    /// - Parameter cell: The cell to be toggled
    func toggleFlag(on cell: Cell) {
        guard !cell.isOpened else {
            return
        }

        cell.isFlagged.toggle()
        
        if hasPlayerWon() {
            showResult = true
            isWon = true
        }

        self.objectWillChange.send()
    }
    
    /// Reset the game board and generate a new one
    func reset() {
        board = Self.generateGameBoard(from: settings)
        showResult = false
        isWon = false
    }
    
    // MARK: - Private Functions
    /// Generate a new game board from the specified game settings
    /// - Parameter settings: The game settings to create the board from
    /// - Returns: A 2D array of cells to play the game with
    private static func generateGameBoard(from settings: GameSettings) -> Board {
        var board = Board()
        
        // Create our board with cells
        for row in 0..<settings.numberOfRows {
            var column = [Cell]()
            
            for col in 0..<settings.numberOfColumns {
                column.append(Cell(row: row, column: col))
            }
            
            board.append(column)
        }
        
        // Place our bombs until they've all been placed
        // This will prevent any potential random dulicates
        var numberOfBombsPlaced = 0
        generateNewBomb: while numberOfBombsPlaced < settings.numberOfBombs {
            // Generate a random number that will fall somewhere in our board
            let randomRow = Int.random(in: 0..<settings.numberOfRows)
            let randomColumn = Int.random(in: 0..<settings.numberOfColumns)
            
            // Make sure the new coordenate isn't already a bomb
            let randomCellStatus = board[randomRow][randomColumn].status
            if randomCellStatus != .bomb {
                board[randomRow][randomColumn].status = .bomb
                numberOfBombsPlaced += 1
            } else {
                continue generateNewBomb
            }
        }
        
        return board
    }
    
    /// Reveal all nearby cells that are not bombs
    /// - Parameter cell: The cell from which nearby cells will be revealed
    private func reveal(for cell: Cell) {
        guard !cell.isOpened, !cell.isFlagged, cell.status != .bomb else {
            return
        }
        
        let exposedCount = getExposedCount(for: cell)
        
        if cell.status != .bomb {
            cell.status = .exposed(exposedCount)
            cell.isOpened = true
        }
        
        if exposedCount == 0 {
            // Get the neighboring cells (top, bottom, left and right)
            // Make sure they are not passed the size of our board
            let topCell = board[max(0, cell.row - 1)][cell.column]
            let bottomCell = board[min(cell.row + 1, board.count - 1)][cell.column]
            let leftCell = board[cell.row][max(0, cell.column - 1)]
            let rightCell = board[cell.row][min(cell.column + 1, board[0].count - 1)]
            
            // Make sure they are not already exposed
            if case .exposed(_) = topCell.status { } else {
                reveal(for: topCell)
            }
            if case .exposed(_) = bottomCell.status { } else {
                reveal(for: bottomCell)
            }
            if case .exposed(_) = leftCell.status { } else {
                reveal(for: leftCell)
            }
            if case .exposed(_) = rightCell.status { } else {
                reveal(for: rightCell)
            }
        }
    }
    
    /// Get the number of bombs that are neighboring the cell
    /// - Parameters:
    ///   - cell: The cell to get the exposed count for
    /// - Returns: The number of bombs that neighbor the cell
    private func getExposedCount(for cell: Cell) -> Int {
        let row = cell.row
        let col = cell.column

        let minRow = max(row - 1, 0)
        let minCol = max(col - 1, 0)
        let maxRow = min(row + 1, board.count - 1)
        let maxCol = min(col + 1, board[0].count - 1)

        var totalBombCount = 0
        for row in minRow...maxRow {
            for col in minCol...maxCol {
                if board[row][col].status == .bomb {
                    totalBombCount += 1
                }
            }
        }

        return totalBombCount
    }
}
