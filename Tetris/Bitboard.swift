//
//  Bitboard.swift
//  Tetris
//
//  Created by Aleksandr Amirkhanov on 01.12.2023.
//

import Foundation

class Bitboard {
    let region: Region
    var buffer: [Int]
    
    init(region: Region) {
        self.region = region
        buffer = Array(repeating: 0, count: region.w * region.h)
    }
    
    func setBuffer(_ x: Int, _ y: Int, _ val: Int) {
        if !region.contains(x, y) {
            return
        }
        
        let rel = toRelativeCoordinates(x, y)
        buffer[rel.x + rel.y * region.w] = val
    }
    
    func getBufferValue(_ x: Int, _ y: Int) -> Int {
        let rel = toRelativeCoordinates(x, y)
        return buffer[rel.x + rel.y * region.w]
    }
    
    private func toRelativeCoordinates(_ x: Int, _ y: Int) -> Vec2 {
        return Vec2(x - region.x, y - region.y)
    }
}
