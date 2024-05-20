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
    
    private var frameNode : SKShapeNode?
    private var brickNode : SKShapeNode?
    private var tetris: TetrisBitboard?
    
    override func didMove(to view: SKView) {
        let brickSize = Int(min((self.size.width - 2 * CGFloat(padding)) / CGFloat(wBricks),
                            (self.size.height - 2 * CGFloat(padding)) / CGFloat(hBricks)).rounded(.towardZero))
        self.brickSize = brickSize
        
        self.frameNode = SKShapeNode.init(rectOf: CGSize(width: brickSize * wBricks, height: brickSize * hBricks))
        if let frameNode {
            frameNode.lineWidth = 2
            frameNode.strokeColor = SKColor.orange
            self.addChild(frameNode)
        }
        
        self.brickNode = SKShapeNode.init(rectOf: CGSize.init(width: brickSize, height: brickSize))
        if let brickNode {
            brickNode.lineWidth = 2
            brickNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        
        self.tetris = TetrisBitboard(region: Region(0, 0, wBricks, hBricks));
        if let tetris = self.tetris {
            let origin = Vec2(0, 0)
            
            let straight = Tetromino(region: Region(origin, Vec2(4, 4)), data: [0, 1, 0, 0,
                                                                                0, 1, 0, 0,
                                                                                0, 1, 0, 0,
                                                                                0, 1, 0, 0])
            
            let square = Tetromino(region: Region(origin, Vec2(2, 2)), data: [1, 1,
                                                                              1, 1])
            
            let tShape = Tetromino(region: Region(origin, Vec2(3, 3)), data: [0, 0, 0,
                                                                              1, 1, 1,
                                                                              0, 0, 1])
            
            let skew = Tetromino(region: Region(origin, Vec2(3, 3)), data: [0, 0, 0,
                                                                            0, 1, 1,
                                                                            1, 1, 0])
            
            tetris.span(instance: skew, val: 5)
        }
    }
    
    private func locate(x: Int, y: Int, brickSize: Int) -> CGPoint {
        let ox = -brickSize * (wBricks - 1) / 2
        let oy = brickSize * (hBricks - 1) / 2
        
        return CGPoint(x: ox + x * brickSize, y: oy - y * brickSize)
    }
    
    override func keyDown(with event: NSEvent) {
        if let tetris = self.tetris {
            let r = tetris.region
            for x in r.x..<r.xMax {
                for y in r.y..<r.yMax {
                    let v = tetris.getBufferValue(x, y)
                    
                    if v > 0 {
                        if let brickSize {
                            if let n = self.brickNode?.copy() as! SKShapeNode? {
                                n.position = locate(x: x, y: y, brickSize: brickSize)
                                n.strokeColor = SKColor.orange
                                self.addChild(n)
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
