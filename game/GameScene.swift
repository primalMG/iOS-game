//
//  GameScene.swift
//  game
//
//  Created by Marcus Gardner on 14/06/2018.
//  Copyright © 2018 Marcus Gardner. All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene {

    var content = false
    
    let player = SKSpriteNode(imageNamed: "ship1.png")
    
    var touchLocaton = CGPoint()
    var score : SKLabelNode! = nil
    var scoreCount = 0 {
        didSet {
            score.text = "Score: \(scoreCount)"
        }
    }
    
    
    override func didMove(to view: SKView) {
       
        createContent()
        points()
        
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addMeteor),
                SKAction.wait(forDuration: 1.0)])
            ))
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(fireProjectile),
                                                      SKAction.wait(forDuration: 0.5)])
        ))
        
        background()
    }
  
    
    func points() {
        score = SKLabelNode(fontNamed: "Chalkduster")
        score.text = "Score: "
        score.fontSize = 25
        score.fontColor = SKColor.black
        score.position = CGPoint(x: 60, y: 700)
        
        addChild(score)
    }
    
    func createContent(){
        player.setScale(0.5)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = PhysicsCategory.player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.meteor
        player.physicsBody?.collisionBitMask = PhysicsCategory.none
        player.physicsBody?.usesPreciseCollisionDetection = true
        
        player.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.1)
        
        addChild(player)
        
    }
    
//    func background(){
//        for i in 0 ... 1 {
//            let backgrounds = SKSpriteNode(imageNamed: "purple.png")
//            backgrounds.name = "space"
//            backgrounds.size = CGSize(width: (self.scene?.size.width)!, height: (self.scene?.size.height)!)
//            backgrounds.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//            backgrounds.position = CGPoint(x: CGFloat(i) * backgrounds.size.width, y: -(self.frame.size.height * 2))
////         backgrounds.position = CGPoint(x: size.width/2, y: size.height/2)
//
//            addChild(backgrounds)
//        }
//    }
    
    func background(){
        let background = SKTexture(imageNamed: "purple.png")
        
        for i in 0 ... 2 {
            let ground = SKSpriteNode(texture: background)
            ground.zPosition = -10
            ground.position = CGPoint(x: background.size().width / 2, y: (background.size().height / 2 + (background.size().height * CGFloat(i))))
            ground.setScale(2.3)
            
            
            
            addChild(ground)
            
            let moveDown = SKAction.moveBy(x: 0, y: -background.size().height, duration: 5)
            let moveReset = SKAction.moveBy(x: 0, y: background.size().height, duration: 0)
            let moveLoop = SKAction.sequence([moveDown, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            ground.run(moveForever)
            
        }
    }
    
    func moveBackground(){
        self.enumerateChildNodes(withName: "space", using: ({
            (node, error) in
            
            node.position.y -= 2
            
            if node.position.y < -((self.scene?.size.height)!) {
                node.position.y += (self.scene?.size.height)! * 3
            }
        }))
    }
    
    

    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func fireProjectile() {
        let projectile = SKSpriteNode(imageNamed: "laserBlue16.png")
        projectile.physicsBody = SKPhysicsBody(rectangleOf: projectile.size)
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.meteor
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
        projectile.physicsBody?.usesPreciseCollisionDetection = true
        
        projectile.setScale(0.5)
        
        projectile.position = player.position
        
        addChild(projectile)
        
        let y = size.height + projectile.size.height * 2
        
        
        
        let action = SKAction.moveTo(y: y + projectile.position.y, duration: 0.5)
        let actionComplete = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([action, actionComplete]))
    }
    
    func addMeteor(){
        //getting the ufo image
        let meteor = SKSpriteNode(imageNamed: "meteorGrey_med2.png")
        meteor.physicsBody = SKPhysicsBody(rectangleOf: meteor.size)
        meteor.physicsBody?.isDynamic = true
        meteor.physicsBody?.categoryBitMask = PhysicsCategory.meteor
        meteor.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
        meteor.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        //ufo.setScale(0.8)
        //random postion along the top of screen (x axis)
        let x = random(min: meteor.size.width/2, max: size.width - meteor.size.width/2)
        
        //positions the ufo slightly off screen
        meteor.position = CGPoint(x: x, y: size.height + meteor.size.height/2)
        
        //add the ufo to the scene
        addChild(meteor)
        
        //ufo speed
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        
        //getting to ufo to move
        let actionMove = SKAction.move(to: CGPoint(x: x, y: -meteor.size.height/2), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        meteor.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    func projectileCollisonWithMeteor(projectile: SKSpriteNode, meteor: SKSpriteNode){
        projectile.removeFromParent()
        meteor.removeFromParent()
        
        
        scoreCount += 1
    }
    
    func MeteorCollisionWithPlayer(meteor: SKSpriteNode, player: SKSpriteNode){
        let reveal = SKTransition.flipVertical(withDuration: 0.5)
        let gameOver = GameOver(size: self.size, won: true)
        view?.presentScene(gameOver, transition: reveal)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            touchLocaton = touch.location(in: self)
            
            playerMovement()
        }
    }
    
    func playerMovement(){
        player.position.x = touchLocaton.x
    }
  
    struct PhysicsCategory {
        static let none : UInt32 = 0
        static let all : UInt32 = UInt32.max
        static let meteor : UInt32 = 0b1
        static let projectile: UInt32 = 0b10
        static let player: UInt32 = 0b101
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        
        collisionOne(contact)
        collisionTwo(contact)
        
        
       
    }
    
    func collisionOne(_ contact: SKPhysicsContact){
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        
        if ((firstBody.categoryBitMask & PhysicsCategory.meteor != 0) && (secondBody.categoryBitMask & PhysicsCategory.projectile != 0)) {
            if let meteor = firstBody.node as? SKSpriteNode, let projectile = secondBody.node as? SKSpriteNode {
                projectileCollisonWithMeteor(projectile: projectile, meteor: meteor)
            }
        }
    }
    
    func collisionTwo(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.meteor !=  0) && (secondBody.categoryBitMask & PhysicsCategory.player != 0)) {
            if let meteor = firstBody.node as? SKSpriteNode, let player = secondBody.node as? SKSpriteNode {
                MeteorCollisionWithPlayer(meteor: meteor, player: player)
            }
        }
    }
    
}
