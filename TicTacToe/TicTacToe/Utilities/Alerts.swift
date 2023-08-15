//  Alerts.swift
//  TicTacToe
//
//  Created by Logan Bowers on 8/15/23.

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext{
    static let humanWin = AlertItem(title: Text("You win!"),
                             message: Text("Great job"),
                             buttonTitle: Text("Reset game"))
    
    static let aiWin = AlertItem(title: Text("You lose!"),
                          message: Text("The machine grows smarter..."),
                          buttonTitle: Text("Reset game"))
    
    static let draw = AlertItem(title: Text("Draw"),
                         message: Text("Well matched"),
                         buttonTitle: Text("Reset game"))
}
