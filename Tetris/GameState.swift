//
//  GaseState.swift
//  Tetris
//
//  Created by Aleksandr Amirkhanov on 24.05.2024.
//

import Foundation

struct GameState {
    // Options, which are set before the game starts
    let tetris: Tetris
    let initialSpeed: Float = 0.5
    let acceleration: Float = 1.1
    let spawnsInLevel = 3
    
    // Options, which can be changed during the game
    var tetromino: Tetromino?
    var isGameOver: Bool = false
    var spawnCounter: Int = 0
    var level: Int {
        return spawnCounter / spawnsInLevel
    }
    var speed: Float {
        return initialSpeed / powf(acceleration, Float(level))
    }
    
    init(tetris: Tetris, tetromino: Tetromino? = nil) {
        self.tetris = tetris
        self.tetromino = tetromino
    }
}
