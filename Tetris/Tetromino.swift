//
//  Tetromino.swift
//  Tetris
//
//  Created by Aleksandr Amirkhanov on 23.03.2024.
//

import Foundation

class Tetromino: Bitboard {
    fileprivate var rotationNum: Int = 0
    
    fileprivate var r: Int = 0
    var rotation: Int {
        get {
            r
        }
        set {
            r = rotationNum == 0 ? 0 : newValue % rotationNum
        }
    }
    
    var colorCode: Int
    
    private init(region: Region, data: [Int], colorCode: Int) {
        self.colorCode = colorCode
        
        super.init(region: region)
        self.buffer = data
    }
    
    init(region: Region, data: [[Int]], colorCode: Int) {
        self.colorCode = colorCode
        
        super.init(region: region)
        
        for d in data {
            addRotation(data: d)
        }
    }
    
    func copy() -> Tetromino {
        let copy = Tetromino(region: self.region, data: self.buffer, colorCode: self.colorCode)
        copy.rotationNum = self.rotationNum
        copy.rotation = self.rotation
        
        return copy
    }
    
    func getBufferWithRotation(point: Vec2) -> Int? {
        if let val = getValue(point: point) {
            return val >> rotation & 0b1
        }
        
        return nil
    }
    
    func addRotation(data: [Int]) {
        if (data.count != region.count) {
            return
        }
        
        for index in 0..<data.count {
            let point = Vec2(region.x + index % region.w, region.y + index / region.w)
            
            if data[index] > 0 {
                let v = getValue(point: point)! | 1 << rotationNum
                setValue(point: point, val: v)
            }
        }
        
        rotationNum += 1
    }
}
