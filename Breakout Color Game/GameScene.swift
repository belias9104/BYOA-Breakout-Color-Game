//
//  GameScene.swift
//  Breakout Color Game
//
//  Created by Benjamin Elias on 5/2/18.
//  Copyright © 2018 period8. All rights reserved.
//

import SpriteKit
import GameplayKit

let ballCategory: UInt32 = 0x1 << 0
let paddleCategory: UInt32 = 0x2 << 1
let borderCategory: UInt32 = 0x2 << 2
let block1Category: UInt32 = 0x3 << 3
let block2Category: UInt32 = 0x4 << 4
let block3Category: UInt32 = 0x5 << 5

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var paddle = SKSpriteNode()
    var ball = SKSpriteNode()
    var block1 = SKSpriteNode()
    var block2 = SKSpriteNode()
    var block3 = SKSpriteNode()
    
    var started = false
    var counter = 0
    var label = SKLabelNode()
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        label = SKLabelNode(text: "0")
        label.fontSize = 100.0
        label.position = CGPoint(x: 0, y: -35)
        addChild(label)
        
        paddle = self.childNode(withName: "paddle") as! SKSpriteNode
        block1 = self.childNode(withName: "block1") as! SKSpriteNode
        block2 = self.childNode(withName: "block2") as! SKSpriteNode
        block3 = self.childNode(withName: "block3") as! SKSpriteNode
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody = border
        
        paddle.physicsBody?.categoryBitMask = paddleCategory
        border.categoryBitMask = borderCategory
        block1.physicsBody?.categoryBitMask = block1Category
        block2.physicsBody?.categoryBitMask = block2Category
        block3.physicsBody?.categoryBitMask = block3Category
        ball.physicsBody?.categoryBitMask = ballCategory
        
    }
    func didBegin(_ contact: SKPhysicsContact) {
        //bitmasks
    }
    func changePaddle(_ node: SKSpriteNode) {
        //paddle color
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
       ball.run(SKAction.moveTo(x: location.x, duration: 0.2))
        ball.run(SKAction.moveTo(x: -location.y, duration: 0.2))
        paddle.run(SKAction.moveTo(y: location.x, duration: 0.2))
        
       
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        paddle.run(SKAction.moveTo(x: location.x, duration: 0.2))
    }
    func changeBlock(_ node: SKSpriteNode) {
        if node.color == UIColor.red{
            node.color = UIColor.orange
        }
        if node.color == UIColor.orange {
            node.color = UIColor.yellow
        }
        if node.color == UIColor.yellow {
            node.color = UIColor.green
        }
        if node.color == UIColor.green {
            node.removeFromParent()
        }
    }
}
    
