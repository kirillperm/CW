//
//  StartStar.swift
//  ColorWars
//
//  Created by Kirill Botalov on 21.07.17.
//  Copyright © 2017 Kirill Botalov. All rights reserved.
//

import SpriteKit

class StartStar: SKSpriteNode {
    
    init(isAi: Bool) {
        
        var textureStar: SKTexture?
        
        if isAi {
            textureStar = SKTexture.init(imageNamed: "StarAi")
        } else {
            textureStar = SKTexture.init(imageNamed: "StarPlayer")
        }

        super.init(texture: textureStar! , color: SKColor.white, size: textureStar!.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animationStartStar(endPosition: CGPoint) {

        self.isHidden = true
        self.position = CGPoint(x: 0, y: 0)
        self.zPosition += 10
        let oldX = self.xScale
        let oldY = self.yScale
        self.xScale *= 10
        self.yScale *= 10

        let timeAction = 1
        let scaleX = SKAction.scaleX(to: oldX, duration: TimeInterval(timeAction))
        let scaleY = SKAction.scaleY(to: oldY, duration: TimeInterval(timeAction))
        let move = SKAction.move(to: endPosition, duration: TimeInterval(timeAction))
        
        let action = SKAction.group([scaleX,scaleY,move])
        
        self.isHidden = false
        self.run(action)
    }
}
