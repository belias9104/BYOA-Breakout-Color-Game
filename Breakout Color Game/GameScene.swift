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
let blockCategory: UInt32 = 0x3 << 3
let leftCategory: UInt32 = 0x4 << 4
let rightCategory: UInt32 = 0x5 << 5
let bottomCategory: UInt32 = 0x6 << 6
let topCategory: UInt32 = 0x7 << 7

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
        
//        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
//        self.physicsBody = border
        
        let bottomLeft = CGPoint(x: frame.origin.x, y: frame.origin.y)
        let bottomRight = CGPoint(x: -frame.origin.x, y: frame.origin.y)
        let topLeft = CGPoint(x: frame.origin.x, y: -frame.origin.y)
        let topRight = CGPoint(x: -frame.origin.x, y: -frame.origin.y)
        
        let bottom = SKNode()
        bottom.name = "bottom"
        bottom.physicsBody = SKPhysicsBody(edgeFrom: bottomLeft, to: bottomRight)
        
        addChild(bottom)
        
        let top = SKNode()
        top.name = "top"
        top.physicsBody = SKPhysicsBody(edgeFrom: topLeft, to: topRight)
        
        addChild(top)
        
        let left = SKNode()
        left.name = "left"
        left.physicsBody = SKPhysicsBody(edgeFrom: bottomLeft, to: topLeft)
        
        addChild(left)
        
        let right = SKNode()
        right.name = "right"
        right.physicsBody = SKPhysicsBody(edgeFrom: bottomRight, to: topRight)
        
        addChild(right)
        
        paddle.physicsBody?.categoryBitMask = paddleCategory
        border.categoryBitMask = borderCategory
//        bottom.physicsBody?.categoryBitMask = bottomCategory
        top.physicsBody?.categoryBitMask = topCategory
        left.physicsBody?.categoryBitMask = leftCategory
        right.physicsBody?.categoryBitMask = rightCategory
        ball.physicsBody?.categoryBitMask = ballCategory
        
        block1.physicsBody?.categoryBitMask = blockCategory
        block2.physicsBody?.categoryBitMask = blockCategory
        block3.physicsBody?.categoryBitMask = blockCategory
        
        ball.physicsBody?.contactTestBitMask = blockCategory | bottomCategory | paddleCategory
        
    }
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.physicsBody?.categoryBitMask == blockCategory {
            changeBlock(contact.bodyA.node as! SKSpriteNode)
        } else if contact.bodyA.node?.physicsBody?.categoryBitMask == bottomCategory {
            //Insert counter or restart here
        }
        print("contact with \(contact.bodyA.node?.name) and \(contact.bodyB.node?.name)")
    }
    func changePaddle(_ node: SKSpriteNode) {
        //paddle color
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !started {
            started = true
            ball.physicsBody?.applyImpulse(CGVector(dx: 300, dy: 300))
        }
        
        let touch = touches.first!
        let location = touch.location(in: self)
        paddle.run(SKAction.moveTo(x: location.x, duration: 0.2))
        
       
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        paddle.run(SKAction.moveTo(x: location.x, duration: 0.2))
    }
    func changeBlock(_ node: SKSpriteNode) {
        if node.color == UIColor.red{
            node.color = UIColor.orange
        } else if node.color == UIColor.orange {
            node.color = UIColor.yellow
        } else if node.color == UIColor.yellow {
            node.color = UIColor.green
        } else if node.color == UIColor.green {
            node.removeFromParent()
        }
    }
    func livesCount(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.physicsBody?.categoryBitMask == bottomCategory {
            label.text = "1"
            removeAllActions()
            if contact.bodyA.node?.physicsBody?.categoryBitMask == bottomCategory{
                label.text = "2"
                removeAllActions()
                if contact.bodyA.node?.physicsBody?.categoryBitMask == bottomCategory{
                    label.text = "Game Over"
                    removeAllActions()
                }
            }
        }
        
    }
}
    
