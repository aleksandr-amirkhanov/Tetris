//
//  Tetromino.swift
//  Tetris
//
//  Created by Aleksandr Amirkhanov on 23.03.2024.
//

import Foundation

class Tetromino: Bitboard {
    fileprivate var variantsNum: Int = 0
    
    fileprivate var r: Int = 0
    var variant: Int {
        get {
            r
        }
        set {
            r = variantsNum == 0 ? 0 : newValue % variantsNum
        }
    }
    
    var colorCode: Int
    
    fileprivate init(region: Region, data: [Int], colorCode: Int) {
        self.colorCode = colorCode
        
        super.init(region: region)
        self.buffer = data
    }
    
    init(region: Region, data: [[Int]], colorCode: Int) {
        self.colorCode = colorCode
        
        super.init(region: region)
        
        for d in data {
            addVariant(data: d)
        }
    }
    
    func copy() -> Tetromino {
        let copy = Tetromino(region: self.region, data: self.buffer, colorCode: self.colorCode)
        copy.variantsNum = self.variantsNum
        copy.variant = self.variant
        
        return copy
    }
    
    override func getBuffer(at: Vec2) -> Int? {
        if let val = super.getBuffer(at: at) {
            return val >> variant & 0b1
        }
        
        return nil
    }
    
    func addVariant(data: [Int]) {
        if (data.count != region.count) {
            return
        }
        
        for index in 0..<data.count {
            let point = Vec2(region.x + index % region.w, region.y + index / region.w)
            
            if data[index] > 0 {
                let v = super.getBuffer(at: point)! | 1 << variantsNum
                setBuffer(at: point, value: v)
            }
        }
        
        variantsNum += 1
    }
}
