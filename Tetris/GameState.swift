//
//  GaseState.swift
//  Tetris
//
//  Created by Aleksandr Amirkhanov on 24.05.2024.
//

import Foundation

struct GameState {
    var tetris: Tetris
    var tetromino: Tetromino?
    var level: Int = 0
    var gameOver: Bool = false
    
    init(tetris: Tetris, tetromino: Tetromino? = nil, level: Int = 0) {
        self.tetris = tetris
        self.tetromino = tetromino
        self.level = level
    }
}
