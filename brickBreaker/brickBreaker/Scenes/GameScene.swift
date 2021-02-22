//
//  GameScene.swift
//  brickBreaker
//
//  Created by Daniel on 19/03/2020.
//  Copyright © 2020 Daniel. All rights reserved.
//

import SpriteKit
import AVKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    // CategoryBitMask for Nodes in game
    let BallCategory   : UInt32 = 0x1 << 0
    let BottomCategory : UInt32 = 0x1 << 1
    let BlockCategory  : UInt32 = 0x1 << 2
    let PaddleCategory : UInt32 = 0x1 << 3
    
    
    var gameOver = false
    
    // Creating bouncing Ball
    let ball = SKSpriteNode(imageNamed: "ball")
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // Ball touching bottom line
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BottomCategory {
            GameOver()
        }
        // Ball touching Paddle
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == PaddleCategory {
            BallTouchPaddle()
        }
        // Ball touching blocks
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BlockCategory {
            BreakBlock(node: secondBody.node!)
        }
    }
    
    func randomFloat(from: CGFloat, to: CGFloat) -> CGFloat {
      let rand: CGFloat = CGFloat(Float(arc4random()) / 0x100000000)
      return (rand) * (to - from) + from
    }
    
    func randomDirection() -> CGFloat {
      let speedFactor: CGFloat = 3.0
      if self.randomFloat(from: 0.0, to: 100.0) >= 50 {
        return -speedFactor
      } else {
        return speedFactor
      }
    }
    
    override func didSimulatePhysics() {
        let maxSpeed: CGFloat = 250.0
                
        let dxSpeed = abs(CGFloat((ball.physicsBody?.velocity.dx)!))
        let dySpeed = abs(CGFloat((ball.physicsBody?.velocity.dy)!))
        
        let speed = sqrt(dxSpeed + dySpeed)
        
        if dxSpeed <= 150.0 {
            ball.physicsBody?.applyImpulse(CGVector(dx: -5.0, dy: 0.0))
        }
        
        if dySpeed <= 150 {
            ball.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 5.0))
        }
        
        if speed > maxSpeed {
                    ball.physicsBody!.linearDamping = 0.2
            } else {
                    ball.physicsBody!.linearDamping = 0.0
            }
        
        // Boucing off the walls physics
        if ball.position.x <= 12 + (ball.frame.width / 2.0)
        {
            ball.physicsBody?.velocity.dx *= 1
        }
        
        if ball.position.x >= 618 - (ball.frame.width / 2.0) {
            ball.physicsBody?.velocity.dx *= -1
        }
    }
    
    func BallTouchPaddle() {
        //  TODO when ball touches paddle in different side to apply different vector
        playSound(sound: bounceSound)
    }
    
    func GameOver() {
        gameOver = true
        self.childNode(withName: "gameOver")?.isHidden = false
        self.childNode(withName: "restart")?.isHidden = false
        self.childNode(withName: "blocks")?.removeAllChildren()
        
        // Changing Ball physics body
        childNode(withName: "ball")?.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0)
        childNode(withName: "ball")?.physicsBody?.isDynamic = false
        childNode(withName: "ball")?.isHidden = true
        playSound(sound: gameOverSound)
    }
    
    //Playing music
    var backgroundSound = SKAction.playSoundFileNamed("background_music.mp3", waitForCompletion: false)
    var brickSound = SKAction.playSoundFileNamed("broken_brick.mp3", waitForCompletion: false)
    var gameOverSound = SKAction.playSoundFileNamed("game_over.mp3", waitForCompletion: false)
    var bounceSound = SKAction.playSoundFileNamed("bounce_sound.mp3", waitForCompletion: false)
    
    func playSound(sound : SKAction) {
        run(sound)
    }
    
    func StartNewGame() {
//        Temporary swithed off , dont know how to stop music and start new one
//        playSound(sound: sound)
        gameOver = false
        // Important method how to delete nodes with same name from scene
        self.enumerateChildNodes(withName: "blocks") {
                node, stop in
            node.run(SKAction.removeFromParent())
        }
        self.childNode(withName: "gameOver")?.isHidden = true
        self.childNode(withName: "restart")?.isHidden = true
        childNode(withName: "ball")?.physicsBody?.isDynamic = true
        self.childNode(withName: "ball")?.position = CGPoint(x: 320, y: 170)
        self.childNode(withName: "ball")?.isHidden = false
        self.childNode(withName: "ball")?.physicsBody?.applyImpulse(CGVector(dx: 5.0, dy: 18.0))
        
        // Creating number of blocks in line
        // and creating number of rows
        // TODO create different levels with different numbers of blocks
        let numberOfBlocks = 6
        let numberOfRows = 9
        let blockWidth = CGFloat(90)
        let blockHight = CGFloat(30)
        let totalBlockWidth = blockWidth * CGFloat(numberOfBlocks) + 10 * (CGFloat(numberOfBlocks - 1))
        
        let xOffset = (frame.width - totalBlockWidth) / 2
        
        
        for i in 0..<numberOfRows {
            for j in 0..<numberOfBlocks {
                    // Creating block and its physicbody
                    var blockName: String = ""
                if i == 0 && i == 4 {
                    blockName = "blockOrange"
                } else if i == 1 || i == 5{
                    blockName = "blockBlue"
                } else if i == 2 || i == 6{
                    blockName = "blockYellow"
                } else if i == 3 || i == 7{
                    blockName = "blockGreen"
                } else {
                    blockName = "blockSilver"
                }
                    let block = SKSpriteNode(imageNamed: blockName)
                    block.name = "blocks"
                    block.size = CGSize(width: 90, height: 30)
                    if j == 0 {
                        block.physicsBody = SKPhysicsBody(texture: block.texture!, size: block.size)
                        block.position = CGPoint(x: xOffset + 45 + CGFloat(j) * blockWidth, y: ((frame.height - 120 - CGFloat(i) * blockHight)) - 10 * CGFloat(i))
                    } else {
                        block.physicsBody = SKPhysicsBody(texture: block.texture!, size: block.size)
                        block.position = CGPoint(x: xOffset + 45 + CGFloat(j) * blockWidth + CGFloat(j) * 10, y: ((frame.height - 120 - CGFloat(i) * blockHight)) - 10 * CGFloat(i))
                    }
                    block.physicsBody!.allowsRotation = false
                    block.physicsBody!.friction = 0.0
                    block.physicsBody!.affectedByGravity = false
                    block.physicsBody!.isDynamic = false
                    block.physicsBody!.categoryBitMask = BlockCategory
                    block.zPosition = 2
                    //                    block.physicsBody?.restitution = 0
                    //                    block.physicsBody?.linearDamping = 0
                    //                    block.physicsBody?.angularDamping = 0
                    addChild(block)
            }
        }
    }
    
    func BreakBlock(node: SKNode) {
        
        // Ball cath in fire
        // Temporary swithed off 
//        let trail = SKEmitterNode(fileNamed: "BallTrail")!
//        ball.addChild(trail)
//        trail.targetNode = ball
//        trail.run(SKAction.sequence([SKAction.wait(forDuration: 0.1), SKAction.removeFromParent()]))
        
        // Setting particles to explode
        playSound(sound: brickSound)
        let particles = SKEmitterNode(fileNamed: "BrokenPlatform")!
        particles.position = node.position
        particles.zPosition = 3
        addChild(particles)
        particles.run(SKAction.sequence([SKAction.wait(forDuration: 1.0), SKAction.removeFromParent()]))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            node.removeFromParent()
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // When game over appers and we click restart below code will execute
        if gameOver == true {
            let touch = touches.first
            let location = touch!.location(in: self)
            let touchedNode = atPoint(location)
            if touchedNode.name == "restart" {
                StartNewGame()
            }
        }
    }
    
    // When you moved finger
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        let previosLocation = touch!.previousLocation(in: self)
        let paddle = childNode(withName: "paddle") as! SKSpriteNode
        var paddleX = paddle.position.x + (touchLocation.x - previosLocation.x)
        paddleX = max(paddleX, paddle.size.width/2)
        paddleX = min(paddleX, size.width - paddle.size.width/2)
        paddle.position = CGPoint(x: paddleX, y: paddle.position.y)
    }
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        // Creating BottomNode
        let bottomRect = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 1)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFrom: bottomRect)
        bottom.physicsBody!.categoryBitMask = BottomCategory
        addChild(bottom)
        
        
        // Creating top Ceilling for bouncing ball
        var ceillingPoints = [CGPoint(x: 0, y: 1280),
                              CGPoint(x: 620, y: 1280)]
        
        let ceilling = SKShapeNode(splinePoints: &ceillingPoints, count: ceillingPoints.count)
        ceilling.physicsBody = SKPhysicsBody(edgeChainFrom: ceilling.path!)
        ceilling.physicsBody?.isDynamic = false
        ceilling.physicsBody?.friction = 0
        ceilling.isHidden = true
        addChild(ceilling)
        
        
        // Creating left side of boucing frame
        var leftPoints = [CGPoint(x: 10, y: 1280),
                          CGPoint(x: 10, y: 0)]
        
        let leftSide = SKShapeNode(splinePoints: &leftPoints, count: leftPoints.count)
        leftSide.physicsBody = SKPhysicsBody(edgeChainFrom: leftSide.path!)
        leftSide.physicsBody?.isDynamic = false
        leftSide.physicsBody?.friction = 0
        leftSide.isHidden = true
        addChild(leftSide)
        
        
        // Creating right side of bouncing frame
        var rightPoints = [CGPoint(x: 620, y: 1280),
                           CGPoint(x: 620, y: 0)]
        
        let rightSide = SKShapeNode(splinePoints: &rightPoints, count: rightPoints.count)
        rightSide.physicsBody = SKPhysicsBody(edgeChainFrom: rightSide.path!)
        rightSide.physicsBody?.isDynamic = false
        rightSide.physicsBody?.friction = 1
        rightSide.isHidden = true
        addChild(rightSide)
        
        // Ball is global var , here are attributes
        let ballRadius = ball.frame.width / 2.0
        ball.name = "ball"
        ball.position = CGPoint(x: 320, y: 170)
        ball.zPosition = 2
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ballRadius)
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.angularDamping = 0
        ball.physicsBody!.categoryBitMask = BallCategory
        addChild(ball)
        ball.physicsBody?.contactTestBitMask = BottomCategory | BlockCategory
        
        
        // Creating blocks in the begining of the app
        StartNewGame()
        
        // Creating paddle
        let paddle = SKSpriteNode(imageNamed: "paddle")
        paddle.name = "paddle"
        paddle.position = CGPoint(x: 320, y: 160)
        paddle.zPosition = 2
        paddle.physicsBody = SKPhysicsBody(texture: paddle.texture!, size: paddle.texture!.size())
        paddle.physicsBody?.isDynamic = false
        paddle.physicsBody?.friction = 0
        paddle.physicsBody?.restitution = 1
        paddle.physicsBody!.categoryBitMask = PaddleCategory
        paddle.physicsBody?.contactTestBitMask = BallCategory
        addChild(paddle)
        
        // Creating GameOver icon
        let gameOver = SKSpriteNode(imageNamed: "game-over")
        gameOver.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 50)
        gameOver.name = "gameOver"
        addChild(gameOver)
        gameOver.isHidden = true
        
        // Creating restart icon
        let restart = SKSpriteNode(imageNamed: "restart")
        restart.name = "restart"
        restart.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 80)
        addChild(restart)
        restart.isHidden = true
    }
}
