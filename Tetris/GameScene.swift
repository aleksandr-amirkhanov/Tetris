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
                          0, 0, 1, 0]]),
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
                          0, 0, 0, 0]]),
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
                          0, 0, 0, 0]]),
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
                          0, 0, 0, 0]]),
        Tetromino(region: Region(Vec2(3, -1), Vec2(4, 4)),
                  data: [[0, 0, 0, 0,
                          0, 1, 1, 0,
                          1, 1, 0, 0,
                          0, 0, 0, 0],
                         [1, 0, 0, 0,
                          1, 1, 0, 0,
                          0, 1, 0, 0,
                          0, 0, 0, 0]]),
        Tetromino(region: Region(Vec2(3, -1), Vec2(4, 4)),
                  data: [[0, 0, 0, 0,
                          1, 1, 0, 0,
                          0, 1, 1, 0,
                          0, 0, 0, 0],
                         [0, 0, 1, 0,
                          0, 1, 1, 0,
                          0, 1, 0, 0,
                          0, 0, 0, 0]]),
        Tetromino(region: Region(Vec2(3, -1), Vec2(4, 4)),
                  data: [[0, 0, 0, 0,
                          0, 1, 1, 0,
                          0, 1, 1, 0,
                          0, 0, 0, 0]])]
        
    override func didMove(to view: SKView) {
        let brickSize = Int(min((self.size.width - 2 * CGFloat(padding)) / CGFloat(wBricks),
                            (self.size.height - 2 * CGFloat(padding)) / CGFloat(hBricks)).rounded(.towardZero))
        self.brickSize = brickSize
        
        let frameNode = SKShapeNode.init(rectOf: CGSize(width: brickSize * wBricks, height: brickSize * hBricks))
        frameNode.lineWidth = 2
        frameNode.strokeColor = SKColor.orange
        self.addChild(frameNode)
        
        self.brickNode = SKShapeNode.init(rectOf: CGSize.init(width: brickSize, height: brickSize))
        if let brickNode {
            brickNode.lineWidth = 2
        }
        
        self.state = GameState(tetris: TetrisBitboard(region: Region(0, 0, wBricks, hBricks)))
        
        span()
    }
    
    private func locate(x: Int, y: Int, brickSize: Int) -> CGPoint {
        let ox = -brickSize * (wBricks - 1) / 2
        let oy = brickSize * (hBricks - 1) / 2
        
        return CGPoint(x: ox + x * brickSize, y: oy - y * brickSize)
    }
    
    private func span() {
        let tetromino = tetrominoCatalog[Int.random(in: 0..<tetrominoCatalog.count)].copy()
        self.state?.tetromino = tetromino
    }
    
    private func updateVisuals() {
        for node in usedNodes {
            node.removeFromParent()
        }
        usedNodes.removeAll()
        
        if let state {
            let tetris = state.tetris
            let r1 = tetris.region
            for x in r1.x..<r1.xMax {
                for y in r1.y..<r1.yMax {
                    if let v = tetris.getBufferValue(x, y) {
                        if v > 0 {
                            if let brickSize {
                                if let n = self.brickNode?.copy() as! SKShapeNode? {
                                    n.position = locate(x: x, y: y, brickSize: brickSize)
                                    n.strokeColor = SKColor.orange
                                    self.addChild(n)
                                    usedNodes.append(n)
                                }
                            }
                        }
                    }
                }
            }
            
            if let tetromino = state.tetromino {
                let r2 = tetromino.region
                for x in r2.x..<r2.xMax {
                    for y in r2.y..<r2.yMax {
                        if let v = state.tetromino?.getBufferWithRotation(x, y) {
                            if v > 0 {
                                if let brickSize {
                                    if let n = self.brickNode?.copy() as! SKShapeNode? {
                                        n.position = locate(x: x, y: y, brickSize: brickSize)
                                        n.strokeColor = SKColor.orange
                                        self.addChild(n)
                                        usedNodes.append(n)
                                    }
                                }
                            }
                        }
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
        if event.keyCode == 123 {
            // left
            _ = move(dx: -1)
        } else if event.keyCode == 124 {
            // right
            _ = move(dx: 1)
        } else if event.keyCode == 49 {
            // spacebar
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
        if let lastUpdate {
            let delta = currentTime - lastUpdate
            
            if (Float(delta) > 0.2) {
                if !move(dy: 1) {
                    if let tetromino = state?.tetromino {
                        self.state?.tetris.place(tetromino: tetromino)
                        self.state?.tetromino = nil
                        span()
                    }
                }
                updateVisuals()
                self.lastUpdate = currentTime
            }
        }
        else {
            updateVisuals()
            self.lastUpdate = currentTime
        }
    }
}
