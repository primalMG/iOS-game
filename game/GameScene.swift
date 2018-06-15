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
    
    override func didMove(to view: SKView) {
        createContent()
      
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addUFO),
                SKAction.wait(forDuration: 1.0)])
            ))
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(fireProjectile),
                                                      SKAction.wait(forDuration: 0.5)])
        ))
    }
    
    func createContent(){
        backgroundColor = SKColor.white
        player.setScale(0.5)
        
        player.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.1)
        
        addChild(player)
    }
    

    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func fireProjectile() {
        let projectile = SKSpriteNode(imageNamed: "laserBlue16.png")
        
        projectile.setScale(0.5)
        
        projectile.position = player.position
        
        addChild(projectile)
        
        let y = size.height + projectile.size.height * 2
        
        
        
        let action = SKAction.moveTo(y: y + projectile.position.y, duration: 0.5)
        let actionComplete = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([action, actionComplete]))
    }
    
    func addUFO(){
        //getting the ufo image
        let ufo = SKSpriteNode(imageNamed: "meteorGrey_med2.png")
        
        //ufo.setScale(0.8)
        //random postion along the top of screen (x axis)
        let x = random(min: ufo.size.width/2, max: size.width - ufo.size.width/2)
        
        //positions the ufo slightly off screen
        ufo.position = CGPoint(x: x, y: size.height + ufo.size.height/2)
        
        //add the ufo to the scene
        addChild(ufo)
        
        //ufo speed
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        
        //getting to ufo to move
        let actionMove = SKAction.move(to: CGPoint(x: x, y: -ufo.size.height/2), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        ufo.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    func addMeteor(){
        //adding the meteors
        let meteor = SKSpriteNode(imageNamed: "")
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
  
    
}
