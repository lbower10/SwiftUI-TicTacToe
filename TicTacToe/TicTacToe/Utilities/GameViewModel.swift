//  GameViewModel.swift
//  TicTacToe
//
//  Created by Logan Bowers on 8/15/23.

import SwiftUI


final class GameViewModel: ObservableObject {
    let cols: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    let winConditions: Set<Set<Int>> = [
        [0,1,2], // top row
        [3,4,5], // middle row
        [6,7,8], // bottom row
        [0,3,6], // left column
        [1,4,7], // middle column
        [2,5,8], // right column
        [2,4,6], // diagonal
        [0,4,8], // diagonal
    ]
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var boardDisabled = false
    @Published var alertItem: AlertItem?
    
    
    func ProcessMove(for position: Int){
        if IsOccupied(in: moves, forIndex: position) {return}
        moves[position] = Move(player: .human, boardPosition: position)
        
        // ------------ Check for human win/draw ------------
        if CheckForWin(for: .human, in: moves){
            alertItem = AlertContext.humanWin
            return
        }
        
        if CheckDraw(in: moves){
            alertItem = AlertContext.draw
            return
        }
        // ------------ check for human win/draw ------------
        
        boardDisabled = true
        
        // ai makes move after half second
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            let aiPos = MakeAIMove(in: moves)
            moves[aiPos] = Move(player: .ai, boardPosition: aiPos)
            
            // ------------ check for ai win/draw ------------
            if CheckForWin(for: .ai, in: moves){
                alertItem = AlertContext.aiWin
                return
            }
            
            if CheckDraw(in: moves){
                alertItem = AlertContext.draw
                return
            }
            // ------------ check for ai win/draw ------------
            
            boardDisabled = false
        }
    }
    
    
    // Check if a certain box is taken
    func IsOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: {$0?.boardPosition == index})
    }
    
    
    // Makes AI move
    func MakeAIMove(in moves: [Move?]) -> Int {
        // if ai can win, then win
        let aiMoves = moves.compactMap{$0}.filter {$0.player == .ai}
        let aiPositions = Set(aiMoves.map{$0.boardPosition})
        
        for condition in winConditions {
            let winPositions = condition.subtracting(aiPositions)
            if winPositions.count == 1{
                let isAvailable = !IsOccupied(in: moves, forIndex: winPositions.first!)
                
                if isAvailable { return winPositions.first!}
            }
        }
        
        // if ai cannot win, block player
        let humanMoves = moves.compactMap{$0}.filter {$0.player == .human}
        let humanPositions = Set(humanMoves.map{$0.boardPosition}) // extract indexes for player
        
        for condition in winConditions {
            let winPositions = condition.subtracting(humanPositions)
            if winPositions.count == 1{
                let isAvailable = !IsOccupied(in: moves, forIndex: winPositions.first!)
                
                if isAvailable { return winPositions.first!}
            }
        }
        
        // take middle square if available
        let center = 4
        if !IsOccupied(in: moves, forIndex: center){
            return center
        }
        
        // cant take middle? take a random available square
        var movePos = Int.random(in: 0..<9)
        while IsOccupied(in: moves, forIndex: movePos){
            movePos = Int.random(in: 0..<9)
        }
        
        return movePos
    }
    
    
    // Check to see if a player won
    func CheckForWin(for player: Player, in moves: [Move?]) -> Bool {
        let playerMoves = moves.compactMap({$0}) // remove all nils
            .filter({$0.player == player}) // filter out opponent moves
        
        // positions where the player has made moves
        let playerPositions = Set(playerMoves.map{ $0.boardPosition })
        
        for condition in winConditions where condition.isSubset(of: playerPositions){
            return true
        }
        
        return false
    }
    
    
    // Check for a draw/if whole board is taken up
    // Check once a win check failed
    func CheckDraw(in moves: [Move?]) -> Bool {
        return moves.compactMap {$0}.count == 9
    }
    
    
    // Reset
    func ResetBoard(){
        moves = Array(repeating: nil, count: 9)
    }
}
