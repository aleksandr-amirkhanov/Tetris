//
//  Vec2.swift
//  Tetris
//
//  Created by Aleksandr Amirkhanov on 23.03.2024.
//

import Foundation

struct Vec2 {
    var x, y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
    
    static func + (left: Vec2, right: Vec2) -> Vec2 {
        return Vec2(left.x + right.x, left.y + right.y)
    }
}
