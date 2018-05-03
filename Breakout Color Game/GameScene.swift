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
let leftCategory: UInt32 = 0x2 << 2
let rightCategory: UInt32 = 0x3 << 3
let bottomCategory: UInt32 = 0x4 << 4
let topCategory: UInt32 = 0x5 << 5

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var paddle = SKSpriteNode()
    var ball = SKSpriteNode()
    
    var started = false
    var counter = 0
    var label = SKLabelNode()
    
    override func didMove(to view: SKView) {
        //contact delegate
    }
    func didBegin(_ contact: SKPhysicsContact) {
        //bitmasks
    }
    func changePaddle(_ node: SKSpriteNode) {
        //paddle color
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //movement of paddles and delay start
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        paddle.run(SKAction.moveTo(x: location.x, duration: 0.2))
        //6
    }
}
    
