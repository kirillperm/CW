//
//  GameSceneControl.swift
//  ColorWars
//
//  Created by Kirill Botalov on 04.07.16.
//  Copyright © 2016 Kirill Botalov. All rights reserved.
//

import SpriteKit

extension GameScene {

    override func buttonTriggered(_ button: ButtonNode) {
        
        let scaleAnimation = SKAction.scale(to: 1, duration: TimeInterval(0.1))
        button.setScale(0.90)
        button.run(scaleAnimation, completion: {
            
            switch button.buttonIdentifier! {
            case .ColorSelector where !self.sceneIsPaused:
                self.turn(color: button.colorButton!)
            case .ColorSelector:
                break
            case .Pause:
                self.stateMachine.enter(GameScenePauseState.self)
            case .Play:
                self.stateMachine.enter(GameSceneActiveState.self)
            case .Replay:
                self.startGame()
            case .NextLevel:
                self.levelManager.slideNextLevel()
                self.startGame()
            case .Stop:
                self.sceneManager.scenePresentation(.menu)
            default:
                super.buttonTriggered(button)
            }
        })
    }
}
