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
            let point = tetromino.getRegionIndex(i)
            
            let val1 = tetromino.getBufferWithRotation(point: point)
            if (val1 == 0) { continue }
            
            if getValue(point: point) ?? 1 == 0 {
                continue
            }
            
            return false
        }
        
        return true
    }
    
    func place(tetromino: Tetromino) {
        for i in 0..<tetromino.buffer.count {
            let point = tetromino.getRegionIndex(i)
            
            let val1 = tetromino.getBufferWithRotation(point: point)
            if (val1 == 0) { continue }
            
            setValue(point: point, val: tetromino.colorCode)
        }
    }
    
    func completedRows() -> [Int] {
        var completedRows: [Int] = []
        for y in 0..<region.yMax {
            var isCompleted = true
            for x in 0..<region.xMax {
                let val = getValue(point: Vec2(x, y))
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
                let point = Vec2(x, y)
                if let val = getValue(point: point) {
                    setValue(point: point + Vec2(0, 1), val: val)
                    setValue(point: point, val: 0)
                }
            }
        }
    }
}
