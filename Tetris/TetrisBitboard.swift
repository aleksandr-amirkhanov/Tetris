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
            
            setBufferValue(x, y, tetromino.colorCode)
        }
    }
    
    func completedRows() -> [Int] {
        var completedRows: [Int] = []
        for y in 0..<region.yMax {
            var isCompleted = true
            for x in 0..<region.xMax {
                let val = getBufferValue(x, y)
                if val == nil || val == 0 {
                    isCompleted = false
                }
            }
            
            if isCompleted {
                completedRows.append(y)
            }
        }
        
        return completedRows
    }
    
    func removeRows(rowNumber: Int) {
        let yEnd = rowNumber
        for y in (0..<yEnd).reversed() {
            for x in 0..<region.xMax {
                if let val = getBufferValue(x, y) {
                    setBufferValue(x, y + 1, val)
                    setBufferValue(x, y, 0)
                }
            }
        }
    }
}
