//
//  GameScene.swift
//  Tetris
//
//  Created by Aleksandr Amirkhanov on 13.04.2024.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    // Game options
    fileprivate let wBricks = 10
    fileprivate let hBricks = 20
    fileprivate let padding = 20
    fileprivate var state: GameState?
    
    // Rendering
    fileprivate var lastUpdate: TimeInterval?
    fileprivate var brickSize: Int?
    fileprivate var brickNode: SKShapeNode?
    fileprivate var usedNodes: [SKShapeNode] = []
    fileprivate var labelNode: SKLabelNode?
    
    fileprivate var tetrominoCatalog: [Tetromino] = [
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
    
    fileprivate let backgroundColor1 = NSColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    fileprivate let backgroundColor2 = NSColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
    
    fileprivate var colors = [1: SKColor(red: 203/255, green: 19/255, blue: 10/255, alpha: 1),
                              2: SKColor(red: 0, green: 131/255, blue: 175/255, alpha: 1),
                              3: SKColor(red: 199/255, green: 84/255, blue: 0, alpha: 1),
                              4: SKColor(red: 0, green: 32/255, blue: 192/255, alpha: 1),
                              5: SKColor(red: 141/255, green: 5/255, blue: 141/255, alpha: 1),
                              6: SKColor(red: 5/255, green: 148/255, blue: 0, alpha: 1),
                              7: SKColor(red: 149/255, green: 122/255, blue: 0, alpha: 1)]
    fileprivate let gameOverColor = NSColor.darkGray
    
    override func didMove(to view: SKView) {
        self.backgroundColor = backgroundColor1
        
        let brickSize = Int(min((self.size.width - 2 * CGFloat(padding)) / CGFloat(wBricks),
                            (self.size.height - 2 * CGFloat(padding)) / CGFloat(hBricks)).rounded(.towardZero))
        self.brickSize = brickSize
        
        let frameNode = SKShapeNode.init(rectOf: CGSize(width: brickSize * wBricks, height: brickSize * hBricks))
        frameNode.lineWidth = 1
        frameNode.strokeColor = backgroundColor2
        frameNode.fillColor = backgroundColor2
        self.addChild(frameNode)
        
        self.brickNode = SKShapeNode.init(rectOf: CGSize.init(width: brickSize, height: brickSize))
        if let brickNode {
            brickNode.lineWidth = 2
        }
        
        labelNode = SKLabelNode.init(fontNamed: "AndaleMono")
        if let labelNode {
            labelNode.fontSize = 14
            labelNode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
            labelNode.position = CGPoint(x: 0, y: (self.size.height + CGFloat(brickSize * hBricks)) / 4)
            labelNode.text = "Hello world"
            self.addChild(labelNode)
        }
        
        self.state = GameState(tetris: Tetris(region: Region(0, 0, wBricks, hBricks)))
        
        span()
    }
    
    fileprivate func locate(point: Vec2, brickSize: Int) -> CGPoint {
        let origin = Vec2(-brickSize * (wBricks - 1) / 2, brickSize * (hBricks - 1) / 2)
        return CGPoint(x: origin.x + point.x * brickSize, y: origin.y - point.y * brickSize)
    }
    
    fileprivate func span() {
        guard let state else {
            return
        }
        
        guard !state.isGameOver else {
            return
        }
        
        let tetromino = tetrominoCatalog[Int.random(in: 0..<tetrominoCatalog.count)].copy()
        if self.state?.tetris.fits(tetromino: tetromino) == true {
            self.state?.tetromino = tetromino
        } else {
            self.state?.isGameOver = true
            state.tetris.place(tetromino: tetromino)
        }
        
        self.state?.spawnCounter += 1
        if let labelNode {
            if let level = self.state?.level {
                labelNode.text = "level: " + String(level)
            }
        }
    }
    
    fileprivate func updateView() {
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
                let point = Vec2(x, y)
                if let v = state.tetris.getBuffer(at: point) {
                    if v == 0 {
                        continue
                    }
                    
                    let n = brickNode.copy() as! SKShapeNode
                    
                    n.position = locate(point: point, brickSize: brickSize)
                    n.strokeColor = backgroundColor2
                    if let color = colors[v] {
                        n.fillColor = state.isGameOver ? gameOverColor : color
                    }
                    self.addChild(n)
                    usedNodes.append(n)
                }
            }
        }
        
        if let tetromino = state.tetromino {
            let r = tetromino.region
            for x in r.x..<r.xMax {
                for y in r.y..<r.yMax {
                    let point = Vec2(x, y)
                    if let v = state.tetromino?.getBuffer(at: point) {
                        if v == 0 {
                            continue
                        }
                        
                        let n = brickNode.copy() as! SKShapeNode
                        
                        n.position = locate(point: point, brickSize: brickSize)
                        n.strokeColor = backgroundColor2
                        if let color = colors[tetromino.colorCode] {
                            n.fillColor = state.isGameOver ? gameOverColor : color
                        }
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
            if state?.tetris.fits(tetromino: modified) == true {
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
                } while state?.tetris.fits(tetromino: copy) == true
                
                copy.region.y -= 1
                state?.tetromino = copy
            }
        } else if event.keyCode == Key.UpArrow.rawValue {
            if let tetromino = state?.tetromino {
                let copy = tetromino.copy()
                copy.variant += 1
                if state?.tetris.fits(tetromino: copy) == true {
                    state?.tetromino = copy
                }
            }
        }
        updateView()
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard let state else {
            return
        }
        
        guard let lastUpdate else {
            updateView()
            self.lastUpdate = currentTime
            
            return
        }
        
        let delta = currentTime - lastUpdate
        
        if Float(delta) > state.speed {
            if !move(dy: 1) {
                if let tetromino = state.tetromino {
                    self.state?.tetris.place(tetromino: tetromino)
                    if let rows = self.state?.tetris.completedRows() {
                        for r in rows {
                            self.state?.tetris.releaseRow(number: r)
                        }
                    }
                    self.state?.tetromino = nil
                    span()
                }
            }
            updateView()
            self.lastUpdate = currentTime
        }
    }
}
