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
    
    private var brickSize: Int?
    
    private var brickNode: SKShapeNode?
    private var tetris: TetrisBitboard?
    private var lastUpdate: TimeInterval?
    private var tetrominoCatalog: [Tetromino] = [
        Tetromino(region: Region(Vec2(3, 0), Vec2(4, 1)), data: [1, 1, 1, 1]),
        Tetromino(region: Region(Vec2(4, 0), Vec2(2, 2)), data: [1, 1,
                                                                 1, 1]),
        Tetromino(region: Region(Vec2(3, 0), Vec2(3, 2)), data: [1, 1, 1,
                                                                 0, 0, 1]),
        Tetromino(region: Region(Vec2(3, 0), Vec2(3, 2)), data: [1, 1, 1,
                                                                 1, 0, 0]),
        Tetromino(region: Region(Vec2(3, 0), Vec2(3, 2)), data: [0, 1, 1,
                                                                 1, 1, 0])]
    
    private var usedNodes: [SKShapeNode] = []
        
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
        
        self.tetris = TetrisBitboard(region: Region(0, 0, wBricks, hBricks))
    }
    
    private func locate(x: Int, y: Int, brickSize: Int) -> CGPoint {
        let ox = -brickSize * (wBricks - 1) / 2
        let oy = brickSize * (hBricks - 1) / 2
        
        return CGPoint(x: ox + x * brickSize, y: oy - y * brickSize)
    }
    
    private func span() {
        if let tetris = self.tetris {
            let t = tetrominoCatalog[Int.random(in: 0..<tetrominoCatalog.count)]
            tetris.span(instance: t, val: 5)
        }
    }
    
    private func updateVisuals() {
        for node in usedNodes {
            node.removeFromParent()
        }
        usedNodes.removeAll()
        
        if let tetris = self.tetris {
            let r = tetris.region
            for x in r.x..<r.xMax {
                for y in r.y..<r.yMax {
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
        }
    }
    
    private func updateLogic() {
        if let tetris {
            tetris.step()
        }
    }
    
    override func keyDown(with event: NSEvent) {
        if tetris?.hasActive() == false {
            span()
        }
        updateVisuals()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let lastUpdate {
            let delta = currentTime - lastUpdate
            
            if (Float(delta) > 0.1) {
                updateLogic()
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
