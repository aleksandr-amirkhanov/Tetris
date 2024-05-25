//
//  TetrisBitboard.swift
//  Tetris
//
//  Created by Aleksandr Amirkhanov on 10.01.2024.
//

import Foundation

class TetrisBitboard: Bitboard {
    func canFit(tetromino: Tetromino) -> Bool {
        for i in 0..<tetromino.buffer.count {
            let (x, y) = tetromino.getRegionIndex(i)
            
            let val1 = tetromino.getBufferWithRotation(x, y)
            if (val1 == 0) { continue }
            
            if getBufferValue(x, y) ?? 1 == 0 {
                continue
            }
            
            return false
        }
        
        return true
    }
    
    func place(tetromino: Tetromino) {
        for i in 0..<tetromino.buffer.count {
            let (x, y) = tetromino.getRegionIndex(i)
            
            let val1 = tetromino.getBufferWithRotation(x, y)
            if (val1 == 0) { continue }
            
            setBufferValue(x, y, 1)
        }
    }
}
