//  TicTacToeHelpers.swift
//  TicTacToe
//
//  Created by Logan Bowers on 8/15/23.

import SwiftUI

// Defines player types: human & ai
enum Player{
    case human, ai
}


// Defines indicators: human -> X, ai -> O
struct Move {
    let player: Player
    let boardPosition: Int
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}


// Text at top
struct GameText: View {
    var body: some View {
        Text("Welcome to TicTacToe")
            .font(.title)
            .padding(15)
            .background(
                Rectangle()
                    .foregroundColor(.purple)
                    .cornerRadius(25)
            )
    }
}


// Defines the TicTacToe Grid view
struct GameSquareView: View {
    var proxy: GeometryProxy
    
    var body: some View {
        Rectangle()
            .frame(width: proxy.size.width/3 - 15,
                   height: proxy.size.width/3 - 15)
            .foregroundColor(.purple)
    }
}


// Handles displaying the X's and O's on screen
struct PlayerIndicator: View {
    var sysImageName: String
    
    var body: some View {
        Image(systemName: sysImageName)
            .resizable()
            .frame(width: 85, height: 85)
    }
}
