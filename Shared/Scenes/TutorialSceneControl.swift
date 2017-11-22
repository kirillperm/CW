//
//  TutorialSceneControl.swift
//  ColorWars
//
//  Created by Kirill Botalov on 20.04.17.
//  Copyright © 2017 Kirill Botalov. All rights reserved.
//

import SpriteKit

extension TutorialScene {
    
    override func buttonTriggered(_ button: ButtonNode) {
        
        let scaleAnimation = SKAction.scale(to: 1, duration: TimeInterval(0.1))
        if button.buttonIdentifier != .Tutorial {
            button.setScale(0.90)
        }
        button.run(scaleAnimation, completion: {
           
            switch button.buttonIdentifier! {
            case .ColorSelector:
                self.prezentStep()
            case .Tutorial:
                self.prezentStep()
            case .Pause:
                self.endTutorial()
            default:
                super.buttonTriggered(button)
            }
        })
    }
}
