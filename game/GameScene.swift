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
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        
        player.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        
        addChild(player)
        
            run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addUFO),
                                                          SKAction.wait(forDuration: 1.0)])
            ))
        
        
        
    }
    
    func createContent(){
        
        let player = SKSpriteNode(imageNamed: "ship1.png")
        
        player.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        
        self.addChild(player)
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addUFO(){
        //getting the ufo image
        let ufo = SKSpriteNode(imageNamed: "ufoBlue.png")
        
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
    
  
    
}
