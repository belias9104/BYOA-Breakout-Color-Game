//
//  GameScene.swift
//  Breakout Color Game
//
//  Created by Benjamin Elias on 5/2/18.
//  Copyright © 2018 period8. All rights reserved.
//

import SpriteKit
import GameplayKit

var backgroundMusic: SKAudioNode!
let ballCategory: UInt32 = 0x1 << 0
let paddleCategory: UInt32 = 0x2 << 1
let borderCategory: UInt32 = 0x2 << 2
let blockCategory: UInt32 = 0x3 << 3
let bottomCategory: UInt32 = 0x6 << 6

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var paddle = SKSpriteNode()
    var ball = SKSpriteNode()
    var block1 = SKSpriteNode()
    var block2 = SKSpriteNode()
    var block3 = SKSpriteNode()
    
    var started = false
    var gameOver = false
    var counter = 3
    var blocks = ["block1", "block2","block3"]
    var label = SKLabelNode()
    var gameOverLabel = SKLabelNode()
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        if let musicURL = Bundle.main.url(forResource: "My Song 68", withExtension: "m4a") {
            backgroundMusic = SKAudioNode(url: musicURL)
            addChild(backgroundMusic)
        }
        label = SKLabelNode(text: String(counter))
        label.fontSize = 100.0
        label.position = CGPoint(x: 0, y: -35)
        addChild(label)
        gameOverLabel = SKLabelNode(text: "Restart?")
        gameOverLabel.fontSize = 60.0
        gameOverLabel.position = CGPoint(x: 0, y: -150)
        
        paddle = self.childNode(withName: "paddle") as! SKSpriteNode
        block1 = self.childNode(withName: "block1") as! SKSpriteNode
        block2 = self.childNode(withName: "block2") as! SKSpriteNode
        block3 = self.childNode(withName: "block3") as! SKSpriteNode
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        
        let bottomLeft = CGPoint(x: frame.origin.x, y: frame.origin.y)
        let bottomRight = CGPoint(x: -frame.origin.x, y: frame.origin.y)
        let topLeft = CGPoint(x: frame.origin.x, y: -frame.origin.y)
        let topRight = CGPoint(x: -frame.origin.x, y: -frame.origin.y)
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody = border
        
        
        
        let bottom = SKNode()
        bottom.name = "bottom"
        bottom.physicsBody = SKPhysicsBody(edgeFrom: bottomLeft, to: bottomRight)
        
        addChild(bottom)
        
        paddle.physicsBody?.categoryBitMask = paddleCategory
        border.categoryBitMask = borderCategory
        bottom.physicsBody?.categoryBitMask = bottomCategory
        ball.physicsBody?.categoryBitMask = ballCategory
        
        block1.physicsBody?.categoryBitMask = blockCategory
        block2.physicsBody?.categoryBitMask = blockCategory
        block3.physicsBody?.categoryBitMask = blockCategory
        
        ball.physicsBody?.contactTestBitMask = blockCategory | bottomCategory | paddleCategory
        }
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.physicsBody?.categoryBitMask == blockCategory && ball.color == block3.color {
            changeBlock(contact.bodyA.node as! SKSpriteNode)
        } else if contact.bodyA.node?.physicsBody?.categoryBitMask == bottomCategory {
            livesCount()
        }
        if contact.bodyB.node?.physicsBody?.categoryBitMask == ballCategory {
            changeBall(ball)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        if gameOver == true && gameOverLabel.frame.contains(location) {
            restartTapped()
        } else {
        if started == false {
            started = true
            ball.physicsBody?.applyImpulse(CGVector(dx: 300, dy: 300))
            blocksStartMoving()
        }
        paddle.run(SKAction.moveTo(x: location.x, duration: 0.2))
        }
        if started == true && gameOver == false {
                checkIfStuck()
        }
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
            blocks.remove(at: 0)
            if blocks.count == 0 {
                label.text = "You win!"
                gameOver = true
                ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                scene!.addChild(gameOverLabel)
            }
        }
    }
    func changeBall(_ node: SKSpriteNode) {
        if node.color == UIColor.red{
            node.color = UIColor.orange
        } else if node.color == UIColor.orange {
            node.color = UIColor.yellow
        } else if node.color == UIColor.yellow {
            node.color = UIColor.green
        } else if node.color == UIColor.green {
            node.color = UIColor.red
        }
    }
    func livesCount() {
        if counter == 1 {
            label.text = "Game Over"
            gameOver = true
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            scene!.addChild(gameOverLabel)
        }
        else {
        counter -= 1
        label.text = String(counter)
        }
    }
    func restartTapped() {
        //restart the game
        if let view = self.view {
            if let scene = SKScene(fileNamed: "GameScene") {
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    func checkIfStuck() {
        if (ball.physicsBody?.velocity.dy)! < CGFloat(10) && (ball.physicsBody?.velocity.dy)! > CGFloat(-10) {
            if (ball.physicsBody?.velocity.dy)! < CGFloat(0) {
                ball.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -300))
            } else if(ball.physicsBody?.velocity.dy)! >= CGFloat(0) {
                ball.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 300))
            }
        } else if (ball.physicsBody?.velocity.dx)! < CGFloat(10) && (ball.physicsBody?.velocity.dx)! > CGFloat(-10) {
            if (ball.physicsBody?.velocity.dx)! < CGFloat(0) {
                ball.physicsBody?.applyImpulse(CGVector(dx: -300, dy: 0))
            } else if(ball.physicsBody?.velocity.dx)! >= CGFloat(0) {
                ball.physicsBody?.applyImpulse(CGVector(dx: 300, dy: 0))
            }
        }
        print("check")
    }
    func blocksStartMoving() {
        block1.run(SKAction.repeatForever(SKAction.sequence([SKAction.moveTo(y: 300, duration: 2), SKAction.moveTo(y: 0, duration: 2)])))
        block2.run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.moveTo(y: 300, duration: 2), SKAction.moveTo(y: 0, duration: 2)])))
        block3.run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 1.0), SKAction.moveTo(y: 300, duration: 2), SKAction.moveTo(y: 0, duration: 2)])))
    }
}
    
