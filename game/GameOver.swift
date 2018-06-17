//
//  GameOver.swift
//  game
//
//  Created by Marcus Gardner on 17/06/2018.
//  Copyright © 2018 Marcus Gardner. All rights reserved.
//

import SpriteKit

class GameOver: SKScene {
    init(size: CGSize, won: Bool){
        super.init(size: size)
        
        backgroundColor = SKColor.white
        
        
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = "You lose"
        label.fontSize = 30
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width/2, y: size.width/2)
        addChild(label)
        
        run(SKAction.sequence([SKAction.wait(forDuration: 3.0), SKAction.run() { [weak self] in
            guard let `self` = self else { return }
            let reveal = SKTransition.flipVertical(withDuration: 0.5)
            let scene = GameScene(size: size)
            self.view?.presentScene(scene, transition: reveal)
            }
            ]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
