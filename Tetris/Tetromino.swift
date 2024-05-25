//
//  Tetromino.swift
//  Tetris
//
//  Created by Aleksandr Amirkhanov on 23.03.2024.
//

import Foundation

class Tetromino: Bitboard {
    private var rotationNum: Int = 0
    fileprivate var r: Int = 0
    var rotation: Int {
        get {
            r
        }
        set {
            r = rotationNum == 0 ? 0 : newValue % rotationNum
        }
    }
    
    private init(region: Region, data: [Int]) {
        super.init(region: region)        
        self.buffer = data
    }
    
    init(region: Region, data: [[Int]]) {
        super.init(region: region)
        
        for d in data {
            addRotation(data: d)
        }
    }
    
    func copy() -> Tetromino {
        let copy = Tetromino(region: self.region, data: self.buffer)
        copy.rotationNum = self.rotationNum
        copy.rotation = self.rotation
        
        return copy
    }
    
    func getBufferWithRotation(_ x: Int, _ y: Int) -> Int? {
        if let val = getBufferValue(x, y) {
            return val >> rotation & 0b1
        }
        
        return nil
    }
    
    func addRotation(data: [Int]) {
        if (data.count != region.count) {
            return
        }
        
        for index in 0..<data.count {
            let x = region.x + index % region.w
            let y = region.y + index / region.w
            
            if data[index] > 0 {
                let v = getBufferValue(x, y)! | 1 << rotationNum
                setBufferValue(x, y, v)
            }
        }
        
        rotationNum += 1
    }
}
