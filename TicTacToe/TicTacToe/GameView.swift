//  GameView.swift
//  TicTacToe
//  Created by Logan Bowers on 8/14/23.

import SwiftUI

struct GameView: View {
    @StateObject private var GVM = GameViewModel() // Utilities
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                Spacer()
                
                GameText() // Utilities
                
                Spacer()

                LazyVGrid(columns: GVM.cols, spacing: 5){
                    ForEach(0..<9) { i in
                        ZStack{
                            GameSquareView(proxy: geometry) // Utilities
                            PlayerIndicator(sysImageName: GVM.moves[i]?.indicator ?? "") // Utilities
                        }
                        .onTapGesture {
                            GVM.ProcessMove(for: i)
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .disabled(GVM.boardDisabled)
            .alert(item: $GVM.alertItem, content: { alertItem in
                Alert(title: alertItem.title, message: alertItem.message, dismissButton: .default(alertItem.buttonTitle, action: {GVM.ResetBoard()}))
            })
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
