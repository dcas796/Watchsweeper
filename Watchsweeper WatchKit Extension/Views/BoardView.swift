//
//  BoardView.swift
//  Watchsweeper WatchKit Extension
//
//  Created by Daniel Ortega on 9/4/22.
//

import SwiftUI

struct BoardView: View {
    @EnvironmentObject var game: Game
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<game.settings.numberOfRows, id: \.self) { row in
                
                HStack(spacing: 0) {
                    ForEach(0..<game.settings.numberOfColumns, id: \.self) { column in
                        
                        CellView(cell: game.board[row][column])
                        
                    }
                }
                
            }
        }
        .alert(isPresented: $game.showResult) {
            Alert(title: Text(game.isWon ? "You have won" : "You have lost"),
                  message: Text("Score: \(game.score)\n" + (game.isWon ? "You flagged all bombs" : "Better luck next time")),
                  primaryButton: .destructive(Text("Reset")) {
                      game.reset()
                  },
                  secondaryButton: .cancel())
        }
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
            .environmentObject(Game())
    }
}
