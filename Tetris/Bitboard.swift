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
    
    func setBufferValue(_ x: Int, _ y: Int, _ val: Int) {
        if !region.contains(x, y) {
            return
        }
        
        buffer[getBufferIndex(x, y)] = val
    }
    
    func getBufferValue(_ x: Int, _ y: Int) -> Int? {
        if !region.contains(x, y) {
            return nil
        }
        
        return buffer[getBufferIndex(x, y)]
    }
    
    func hasFlag(x: Int, y: Int, flag: Int) -> Bool? {
        if let v = getBufferValue(x, y) {
            return v & flag > 0
        }
        
        return nil
    }
    
    func modifyBuffer(modifier: (Int) -> Int) {
        for i in 0..<buffer.count {
            buffer[i] = modifier(buffer[i])
        }
    }
    
    private func getBufferIndex(_ x: Int, _ y: Int) -> Int {
        return x - region.x + (y - region.y) * region.w
    }
    
    func getRegionIndex(_ i: Int) -> (Int, Int) {
        return (i % region.w + region.x, Int(i / region.w) + region.y)
    }
}
