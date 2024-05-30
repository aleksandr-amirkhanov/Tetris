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
    
    func setBuffer(at: Vec2, value: Int) {
        guard region.contains(point: at) else {
            return
        }
        
        buffer[toIndex(point: at)] = value
    }
    
    func getBuffer(at: Vec2) -> Int? {
        guard region.contains(point: at) else {
            return nil
        }
        
        return buffer[toIndex(point: at)]
    }
    
    fileprivate func toIndex(point: Vec2) -> Int {
        return point.x - region.x + (point.y - region.y) * region.w
    }
    
    internal func toPoint(index: Int) -> Vec2 {
        return Vec2(index % region.w + region.x, Int(index / region.w) + region.y)
    }
}
