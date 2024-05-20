//
//  TetrisBitboard.swift
//  Tetris
//
//  Created by Aleksandr Amirkhanov on 10.01.2024.
//

import Foundation

class TetrisBitboard: Bitboard {
    // The mask for the active tetromino
    let activeMask: Int = 1 << 8
    
    func span(instance: Tetromino, val: Int) {
        if !region.contains(instance.region) {
            return
        }
        
        let ir = instance.region
        for x in ir.x..<ir.xMax {
            for y in ir.y..<ir.yMax {
                if (instance.getBufferValue(x, y) > 0) {
                    setBuffer(x, y, val ^ activeMask)
                }
            }
        }
    }
    
    fileprivate func moveDown() {
        let r = region
        
        for x in r.x..<r.xMax {
            for y in (r.y..<r.yMax-1).reversed() {
                if getBufferValue(x, y) & activeMask > 0 {
                    setBuffer(x, y + 1 , getBufferValue(x, y))
                    setBuffer(x, y, 0)
                }
            }
        }
    }
    
    fileprivate func setInactive() {
        let r = region
        
        for x in r.x..<r.xMax {
            for y in (r.y..<r.yMax).reversed() {
                let v = getBufferValue(x, y)
                if v & activeMask > 0 {
                    setBuffer(x, y, v ^ activeMask)
                }
            }
        }
    }
    
    fileprivate func canMove() -> Bool {
        let r = region
        
        for x in r.x..<r.xMax {
            for y in (r.y+1..<r.yMax).reversed() {
                let isActive = getBufferValue(x, y) & activeMask > 0
                if !isActive {
                    continue
                }
                
                let onBottom = !region.contains(x, y + 1)
                if onBottom {
                    return false
                }
                
                let hasSpace = getBufferValue(x, y + 1) == 0 || getBufferValue(x, y + 1) & activeMask > 0
                if !hasSpace {
                    return false
                }
            }
        }
        
        return true
    }
    
    func step() {
        if canMove() {
            moveDown()
        } else {
            setInactive()
        }
    }
}
