//
//  TetrisBitboard.swift
//  Tetris
//
//  Created by Aleksandr Amirkhanov on 10.01.2024.
//

import Foundation

class Tetris: Bitboard {
    func fits(tetromino: Tetromino) -> Bool {
        for i in 0..<tetromino.buffer.count {
            let point = tetromino.toPoint(index: i)
            
            if (tetromino.getBufferWithRotation(point: point) != 0 &&
                getBuffer(at: point) != 0) {
                return false
            }
        }
        
        return true
    }
    
    func place(tetromino: Tetromino) {
        for i in 0..<tetromino.buffer.count {
            let point = tetromino.toPoint(index: i)
            
            if (tetromino.getBufferWithRotation(point: point) != 0) {
                setBuffer(at: point, value: tetromino.colorCode)
            }
        }
    }
    
    func filledRows() -> [Int] {
        var completedRows: [Int] = []
        
        for y in 0..<region.yMax {
            var isFilled = true
            
            for x in 0..<region.xMax {
                let val = getBuffer(at: Vec2(x, y))
                if val == nil || val == 0 {
                    isFilled = false
                }
            }
            
            if isFilled {
                completedRows.append(y)
            }
        }
        
        return completedRows
    }
    
    func removeRow(number: Int) {
        for y in (0..<number).reversed() {
            for x in 0..<region.xMax {
                let point = Vec2(x, y)
                if let val = getBuffer(at: point) {
                    setBuffer(at: point + Vec2(0, 1), value: val)
                    setBuffer(at: point, value: 0)
                }
            }
        }
    }
}
