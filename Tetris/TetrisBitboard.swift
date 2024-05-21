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
        
        for i in 0..<instance.buffer.count {
            if instance.buffer[i] > 0 {
                let (x, y) = instance.getRegionIndex(i)
                setBufferValue(x, y, val ^ activeMask)
            }
        }
    }
    
    func hasActive() -> Bool {
        for v in buffer {
            if v & activeMask > 0 {
                return true
            }
        }
        
        return false
    }
    
    fileprivate func moveDown() {
        let r = region
        
        for x in r.x..<r.xMax {
            for y in (r.y..<r.yMax-1).reversed() {
                if hasFlag(x: x, y: y, flag: activeMask) == true {
                    setBufferValue(x, y + 1 , getBufferValue(x, y)!)
                    setBufferValue(x, y, 0)
                }
            }
        }
    }
    
    fileprivate func setInactive() {
        modifyBuffer(modifier: { (v: Int) -> Int in return v & ~activeMask })
    }
    
    fileprivate func canMove() -> Bool {
        let r = region
        
        for x in r.x..<r.xMax {
            for y in (r.y..<r.yMax).reversed() {
                let isActive = hasFlag(x: x, y: y, flag: activeMask) == true
                if !isActive {
                    continue
                }
                
                let onBottom = !region.contains(x, y + 1)
                if onBottom {
                    return false
                }
                
                let hasSpace = getBufferValue(x, y + 1) == 0 || hasFlag(x: x, y: y + 1, flag: activeMask) == true
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
