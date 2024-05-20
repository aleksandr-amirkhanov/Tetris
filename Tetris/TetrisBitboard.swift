//
//  TetrisBitboard.swift
//  Tetris
//
//  Created by Aleksandr Amirkhanov on 10.01.2024.
//

import Foundation

class TetrisBitboard: Bitboard {
    func span(instance: Tetromino, val: Int) {
        if !region.contains(instance.region) {
            return
        }
        
        let ir = instance.region
        for x in ir.x..<ir.xMax {
            for y in ir.y..<ir.yMax {
                if (instance.getBufferValue(x, y) > 0) {
                    setBuffer(x, y, val)
                }
            }
        }
    }
    
    func step() {
        // Currently it is a naive implementation
        let r = region
        for x in r.x..<r.xMax {
            for y in (r.y..<r.yMax).reversed() {
                setBuffer(x, y + 1, getBufferValue(x, y))
                setBuffer(x, y, 0)
            }
        }
    }
}
