//
//  GameScene.swift
//  Tetris
//
//  Created by Aleksandr Amirkhanov on 13.04.2024.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var frameNode : SKShapeNode?
    private var brickNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        let wBricks: CGFloat = 10
        let hBricks: CGFloat = 20
        let padding: CGFloat = 20
        
        let brickSize = min((self.size.width - 2 * padding) / wBricks,
                            (self.size.height - 2 * padding) / hBricks).rounded(.towardZero)
        
        self.frameNode = SKShapeNode.init(rectOf: CGSize(width: brickSize * wBricks, height: brickSize * hBricks))
        if let frameNode = self.frameNode {
            frameNode.lineWidth = 2
            frameNode.strokeColor = SKColor.orange
            self.addChild(frameNode)
        }
        
        self.brickNode = SKShapeNode.init(rectOf: CGSize.init(width: brickSize, height: brickSize))
        
        if let brickNode = self.brickNode {
            brickNode.lineWidth = 2
            brickNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    override func keyDown(with event: NSEvent) {
        
    }
    
    override func mouseDown(with event: NSEvent) {
        if let n = self.brickNode?.copy() as! SKShapeNode? {
            n.position = event.location(in: self)
            n.strokeColor = SKColor.orange
            self.addChild(n)
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
