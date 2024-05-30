//
//  GameScene.swift
//  Tetris
//
//  Created by Aleksandr Amirkhanov on 13.04.2024.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {    
    let wBricks = 10
    let hBricks = 20
    let padding = 20
    
    let initialSpeed: Float = 0.5
    let spawnsInLevel = 3
    let acceleration: Float = 1.1
    
    var spawnCounter: Int?
    
    private var state: GameState?
    
    private var lastUpdate: TimeInterval?
    
    // Visualisation
    private var brickSize: Int?
    private var brickNode: SKShapeNode?
    private var usedNodes: [SKShapeNode] = []
    
    private var tetrominoCatalog: [Tetromino] = [
        Tetromino(region: Region(Vec2(3, -1), Vec2(4, 4)),
                  data: [[0, 0, 0, 0,
                          1, 1, 1, 1,
                          0, 0, 0, 0,
                          0, 0, 0, 0],
                         [0, 0, 1, 0,
                          0, 0, 1, 0,
                          0, 0, 1, 0,
                          0, 0, 1, 0]],
                 colorCode: 1),
        Tetromino(region: Region(Vec2(3, -1), Vec2(4, 4)),
                  data: [[0, 0, 0, 0,
                          1, 1, 1, 0,
                          0, 1, 0, 0,
                          0, 0, 0, 0],
                         [0, 1, 0, 0,
                          1, 1, 0, 0,
                          0, 1, 0, 0,
                          0, 0, 0, 0],
                         [0, 0, 0, 0,
                          0, 1, 0, 0,
                          1, 1, 1, 0,
                          0, 0, 0, 0],
                         [0, 1, 0, 0,
                          0, 1, 1, 0,
                          0, 1, 0, 0,
                          0, 0, 0, 0]],
                  colorCode: 2),
        Tetromino(region: Region(Vec2(3, -1), Vec2(4, 4)),
                  data: [[0, 0, 0, 0,
                          1, 1, 1, 0,
                          1, 0, 0, 0,
                          0, 0, 0, 0],
                         [1, 1, 0, 0,
                          0, 1, 0, 0,
                          0, 1, 0, 0,
                          0, 0, 0, 0],
                         [0, 0, 0, 0,
                          0, 0, 1, 0,
                          1, 1, 1, 0,
                          0, 0, 0, 0],
                         [0, 1, 0, 0,
                          0, 1, 0, 0,
                          0, 1, 1, 0,
                          0, 0, 0, 0]],
                  colorCode: 3),
        Tetromino(region: Region(Vec2(3, -1), Vec2(4, 4)),
                  data: [[0, 0, 0, 0,
                          1, 1, 1, 0,
                          0, 0, 1, 0,
                          0, 0, 0, 0],
                         [0, 1, 0, 0,
                          0, 1, 0, 0,
                          1, 1, 0, 0,
                          0, 0, 0, 0],
                         [0, 0, 0, 0,
                          1, 0, 0, 0,
                          1, 1, 1, 0,
                          0, 0, 0, 0],
                         [0, 1, 1, 0,
                          0, 1, 0, 0,
                          0, 1, 0, 0,
                          0, 0, 0, 0]],
                  colorCode: 4),
        Tetromino(region: Region(Vec2(3, -1), Vec2(4, 4)),
                  data: [[0, 0, 0, 0,
                          0, 1, 1, 0,
                          1, 1, 0, 0,
                          0, 0, 0, 0],
                         [1, 0, 0, 0,
                          1, 1, 0, 0,
                          0, 1, 0, 0,
                          0, 0, 0, 0]],
                  colorCode: 5),
        Tetromino(region: Region(Vec2(3, -1), Vec2(4, 4)),
                  data: [[0, 0, 0, 0,
                          1, 1, 0, 0,
                          0, 1, 1, 0,
                          0, 0, 0, 0],
                         [0, 0, 1, 0,
                          0, 1, 1, 0,
                          0, 1, 0, 0,
                          0, 0, 0, 0]],
                  colorCode: 6),
        Tetromino(region: Region(Vec2(3, -1), Vec2(4, 4)),
                  data: [[0, 0, 0, 0,
                          0, 1, 1, 0,
                          0, 1, 1, 0,
                          0, 0, 0, 0]],
                  colorCode: 7)]
    
    private var colours = [1: SKColor(red: 203/255, green: 19/255, blue: 10/255, alpha: 1),
                           2: SKColor(red: 0, green: 131/255, blue: 175/255, alpha: 1),
                           3: SKColor(red: 199/255, green: 84/255, blue: 0, alpha: 1),
                           4: SKColor(red: 0, green: 32/255, blue: 192/255, alpha: 1),
                           5: SKColor(red: 141/255, green: 5/255, blue: 141/255, alpha: 1),
                           6: SKColor(red: 5/255, green: 148/255, blue: 0, alpha: 1),
                           7: SKColor(red: 149/255, green: 122/255, blue: 0, alpha: 1)]
    
    private let backgroundColour1 = NSColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    private let backgroundColour2 = NSColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
    private let gameOverColour = NSColor.darkGray
    private let defaultColour = NSColor.darkGray
        
    override func didMove(to view: SKView) {
        self.backgroundColor = backgroundColour1
        
        let brickSize = Int(min((self.size.width - 2 * CGFloat(padding)) / CGFloat(wBricks),
                            (self.size.height - 2 * CGFloat(padding)) / CGFloat(hBricks)).rounded(.towardZero))
        self.brickSize = brickSize
        
        let frameNode = SKShapeNode.init(rectOf: CGSize(width: brickSize * wBricks, height: brickSize * hBricks))
        frameNode.lineWidth = 1
        frameNode.strokeColor = backgroundColour2
        frameNode.fillColor = backgroundColour2
        self.addChild(frameNode)
        
        self.brickNode = SKShapeNode.init(rectOf: CGSize.init(width: brickSize, height: brickSize))
        if let brickNode {
            brickNode.lineWidth = 2
        }
        
        self.state = GameState(tetris: TetrisBitboard(region: Region(0, 0, wBricks, hBricks)))
        self.spawnCounter = 0
        
        span()
    }
    
    private func locate(x: Int, y: Int, brickSize: Int) -> CGPoint {
        let ox = -brickSize * (wBricks - 1) / 2
        let oy = brickSize * (hBricks - 1) / 2
        
        return CGPoint(x: ox + x * brickSize, y: oy - y * brickSize)
    }
    
    private func span() {
        guard let state else {
            return
        }
        
        guard !state.gameOver else {
            return
        }
        
        let tetromino = tetrominoCatalog[Int.random(in: 0..<tetrominoCatalog.count)].copy()
        if self.state?.tetris.canFit(tetromino: tetromino) == true {
            self.state?.tetromino = tetromino
            
            self.spawnCounter? += 1
            if self.spawnCounter == spawnsInLevel {
                self.state?.level += 1
                self.spawnCounter = 0
            }
        } else {
            self.state?.gameOver = true
            state.tetris.place(tetromino: tetromino)
        }
    }
    
    private func updateVisuals() {
        guard let brickSize else {
            return
        }
        guard let brickNode else {
            return
        }
        guard let state else {
            return
        }
        
        for node in usedNodes {
            node.removeFromParent()
        }
        usedNodes.removeAll()
        
        let r = state.tetris.region
        for x in r.x..<r.xMax {
            for y in r.y..<r.yMax {
                if let v = state.tetris.getValue(point: Vec2(x, y)) {
                    if v == 0 {
                        continue
                    }
                    
                    let n = brickNode.copy() as! SKShapeNode
                    
                    n.position = locate(x: x, y: y, brickSize: brickSize)
                    n.strokeColor = backgroundColour2
                    n.fillColor = state.gameOver ? gameOverColour : colours[v] ?? defaultColour
                    self.addChild(n)
                    usedNodes.append(n)
                }
            }
        }
        
        if let tetromino = state.tetromino {
            let r = tetromino.region
            for x in r.x..<r.xMax {
                for y in r.y..<r.yMax {
                    if let v = state.tetromino?.getBufferWithRotation(point: Vec2(x, y)) {
                        if v == 0 {
                            continue
                        }
                        
                        let n = brickNode.copy() as! SKShapeNode
                        
                        n.position = locate(x: x, y: y, brickSize: brickSize)
                        n.strokeColor = backgroundColour2
                        n.fillColor = state.gameOver ? gameOverColour : colours[tetromino.colorCode] ?? defaultColour
                        self.addChild(n)
                        usedNodes.append(n)
                    }
                }
            }
        }
    }
    
    fileprivate func move(dx: Int = 0, dy: Int = 0) -> Bool {
        if let tetromino = state?.tetromino {
            let modified = tetromino.copy()
            modified.region.x += dx
            modified.region.y += dy
            if state?.tetris.canFit(tetromino: modified) == true {
                state?.tetromino = modified
                return true
            }
        }
        
        return false
    }
    
    override func keyDown(with event: NSEvent) {
        if event.keyCode == Key.LeftArrow.rawValue {
            _ = move(dx: -1)
        } else if event.keyCode == Key.RightArrow.rawValue {
            _ = move(dx: 1)
        } else if event.keyCode == Key.DownArrow.rawValue {
            if let tetromino = state?.tetromino {
                let copy = tetromino.copy()
                repeat {
                    copy.region.y += 1
                } while state?.tetris.canFit(tetromino: copy) == true
                
                copy.region.y -= 1
                state?.tetromino = copy
            }
        } else if event.keyCode == Key.SpaceBar.rawValue {
            if let tetromino = state?.tetromino {
                let copy = tetromino.copy()
                copy.rotation += 1
                if state?.tetris.canFit(tetromino: copy) == true {
                    state?.tetromino = copy
                }
            }
        }
        updateVisuals()
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard let state else {
            return
        }
        
        guard let lastUpdate else {
            updateVisuals()
            self.lastUpdate = currentTime
            
            return
        }
        
        let delta = currentTime - lastUpdate
        
        if Float(delta) > initialSpeed / powf(acceleration, Float(state.level)) {
            if !move(dy: 1) {
                if let tetromino = state.tetromino {
                    self.state?.tetris.place(tetromino: tetromino)
                    if let rows = self.state?.tetris.completedRows() {
                        for r in rows {
                            self.state?.tetris.removeRows(rowNumber: r)
                        }
                    }
                    self.state?.tetromino = nil
                    span()
                }
            }
            updateVisuals()
            self.lastUpdate = currentTime
        }
    }
}
