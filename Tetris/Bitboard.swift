//
//  Bitboard.swift
//  Tetris
//
//  Created by Aleksandr Amirkhanov on 01.12.2023.
//

import Foundation

class Bitboard {
    var region: Region
    
    private var b: [Int]
    var buffer : [Int] {
        get {
            b
        } set {
            guard newValue.count == self.region.count else {
                return
            }
            
            b = newValue
        }
    }
    
    init(region: Region) {
        self.region = region
        b = Array(repeating: 0, count: region.w * region.h)
    }
    
    func setValue(point: Vec2, val: Int) {
        guard region.contains(point: point) else {
            return
        }
        
        buffer[getBufferIndex(point: point)] = val
    }
    
    func getValue(point: Vec2) -> Int? {
        guard region.contains(point: point) else {
            return nil
        }
        
        return buffer[getBufferIndex(point: point)]
    }
    
    fileprivate func getBufferIndex(point: Vec2) -> Int {
        return point.x - region.x + (point.y - region.y) * region.w
    }
    
    internal func getRegionIndex(_ i: Int) -> Vec2 {
        return Vec2(i % region.w + region.x, Int(i / region.w) + region.y)
    }
}
