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
    
    func moveLeft() {
        if !canMove(shift: Vec2(-1, 0)) {
            return
        }
        
        let r = region
        
        for x in r.x+1..<r.xMax {
            for y in r.y..<r.yMax {
                if hasFlag(x: x, y: y, flag: activeMask) == true {
                    setBufferValue(x - 1, y , getBufferValue(x, y)!)
                    setBufferValue(x, y, 0)
                }
            }
        }
    }
    
    func moveRight() {
        if !canMove(shift: Vec2(1, 0)) {
            return
        }
        
        let r = region
        
        for x in (r.x..<r.xMax-1).reversed() {
            for y in r.y..<r.yMax {
                if hasFlag(x: x, y: y, flag: activeMask) == true {
                    setBufferValue(x + 1, y , getBufferValue(x, y)!)
                    setBufferValue(x, y, 0)
                }
            }
        }
    }
    
    fileprivate func moveDown() -> Bool {
        if !canMove(shift: Vec2(0, 1)) {
            return false
        }
        
        let r = region
        
        for x in r.x..<r.xMax {
            for y in (r.y..<r.yMax-1).reversed() {
                if hasFlag(x: x, y: y, flag: activeMask) == true {
                    setBufferValue(x, y + 1 , getBufferValue(x, y)!)
                    setBufferValue(x, y, 0)
                }
            }
        }
        
        return true
    }
    
    fileprivate func setInactive() {
        modifyBuffer(modifier: { (v: Int) -> Int in return v & ~activeMask })
    }
    
    fileprivate func canMove(shift: Vec2) -> Bool {
        let r = region
        
        for x in r.x..<r.xMax {
            for y in (r.y..<r.yMax).reversed() {
                let isActive = hasFlag(x: x, y: y, flag: activeMask) == true
                if !isActive {
                    continue
                }
                
                let outOfRegion = !region.contains(x + shift.x, y + shift.y)
                if outOfRegion {
                    return false
                }
                
                let hasSpace = getBufferValue(x + shift.x, y + shift.y) == 0 || hasFlag(x: x + shift.x, y: y + shift.y, flag: activeMask) == true
                if !hasSpace {
                    return false
                }
            }
        }
        
        return true
    }
    
    func step() {
        if !moveDown() {
            setInactive()
        }
    }
}
