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
    
    func setBufferValue(_ x: Int, _ y: Int, _ val: Int) {
        guard region.contains(x, y) else {
            return
        }
        
        buffer[getBufferIndex(x, y)] = val
    }
    
    func getBufferValue(_ x: Int, _ y: Int) -> Int? {
        guard region.contains(x, y) else {
            return nil
        }
        
        return buffer[getBufferIndex(x, y)]
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
