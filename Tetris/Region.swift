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
        } set {
            width = max(newValue, 0)
        }
    }
    
    private var height = 0
    var h : Int {
        get {
            height
        } set {
            height = max(newValue, 0)
        }
    }
    
    var origin: Vec2 {
        get {
            return Vec2(x, y)
        } set {
            x = newValue.x
            y = newValue.y
        }
    }
    
    var xMax: Int {
        return x + w
    }
    
    var yMax: Int {
        return y + h
    }
    
    var count: Int {
        return w * h
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
    
    func contains(point: Vec2) -> Bool {
        return point.x >= self.x && point.x < self.xMax && point.y >= self.y && point.y < self.yMax
    }
    
    func contains(_ another: Region) -> Bool {
        return another.x >= self.x && another.xMax <= self.xMax && another.y >= self.y && another.yMax <= self.yMax
    }
}
