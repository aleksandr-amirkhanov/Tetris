//
//  GaseState.swift
//  Tetris
//
//  Created by Aleksandr Amirkhanov on 24.05.2024.
//

import Foundation

struct GameState {
    var tetris: TetrisBitboard
    var tetromino: Tetromino?
    var level: Int = 0
    
    init(tetris: TetrisBitboard, tetromino: Tetromino? = nil, level: Int = 0) {
        self.tetris = tetris
        self.tetromino = tetromino
        self.level = level
    }
}
