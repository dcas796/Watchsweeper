//
//  CellView.swift
//  Watchsweeper WatchKit Extension
//
//  Created by Daniel Ortega on 9/4/22.
//

import SwiftUI

struct CellView: View {
    // Our game will live at the top most level
    // which will prevent us from having to pass around a game object
    // to subviews
    // Since we are a subview, we have access to the EnvObject here.
    @EnvironmentObject var game: Game
    var cell: Cell
    
    var body: some View {
        cell.image
            .resizable()
            .scaledToFill()
            .frame(width: game.settings.squareSize,
                   height: game.settings.squareSize,
                   alignment: .center)
            .onTapGesture(count: 2) {
                game.toggleFlag(on: cell)
            }
            .onLongPressGesture {
                game.toggleFlag(on: cell)
            }
            .onTapGesture {
                game.click(on: cell)
            }
    }
}

struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        CellView(cell: Cell(row: 0, column: 0))
            .environmentObject(Game())
    }
}
