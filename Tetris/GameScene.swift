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
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        self.frameNode = SKShapeNode.init(rectOf: CGSize(width: 310, height: 620), cornerRadius: 0)
        if let frameNode = self.frameNode {
            frameNode.lineWidth = 2
            frameNode.strokeColor = SKColor.orange
            self.addChild(frameNode)
        }
        
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    override func keyDown(with event: NSEvent) {
        
    }
    
    override func mouseDown(with event: NSEvent) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = event.location(in: self)
            n.strokeColor = SKColor.orange
            self.addChild(n)
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
