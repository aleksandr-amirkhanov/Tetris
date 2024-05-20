//
//  Tetromino.swift
//  Tetris
//
//  Created by Aleksandr Amirkhanov on 23.03.2024.
//

import Foundation

class Tetromino: Bitboard {
    init(region: Region, data: [Int]) {
        super.init(region: region)
        
        if (data.count != region.w * region.h) {
            return
        }
        
        for index in 0..<data.count {
            setBuffer(region.x + index % region.w,
                      region.y + index / region.w,
                      data[index])
        }
    }
}
