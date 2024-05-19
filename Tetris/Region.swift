//
//  Area.swift
//  Tetris
//
//  Created by Aleksandr Amirkhanov on 03.12.2023.
//

import Foundation

struct Region {
    var x, y: Int
    
    private var width = 0
    var w : Int {
        get {
            width
        }
        set {
            width = max(newValue, 0)
        }
    }
    
    private var height = 0
    var h : Int {
        get {
            height
        }
        set {
            height = max(newValue, 0)
        }
    }
    
    var xMax : Int {
        return x + w
    }
    
    var yMax : Int {
        return y + h
    }

    init(_ x: Int, _ y: Int, _ w: Int, _ h: Int) {
        self.x = x
        self.y = y
        self.w = w
        self.h = h
    }
    
    init(_ origin: Vec2, _ size: Vec2) {
        self.init(origin.x, origin.y, size.x, size.y)
    }
    
    func contains(_ x: Int, _ y: Int) -> Bool {
        return x >= self.x && x <= self.xMax && y >= self.y && y <= self.yMax
    }
    
    func contains(_ another: Region) -> Bool {
        return another.x >= self.x && another.xMax <= self.xMax && another.y >= self.y && another.yMax <= self.yMax
    }
}
