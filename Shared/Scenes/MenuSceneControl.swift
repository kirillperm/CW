//
//  MenuSceneControl.swift
//  ColorWars
//
//  Created by Kirill Botalov on 25.07.16.
//  Copyright © 2016 Kirill Botalov. All rights reserved.
//

import SpriteKit

extension MenuScene {

    override func buttonTriggered(_ button: ButtonNode) {
        let scaleAnimation = SKAction.scale(to: 1, duration: TimeInterval(0.1))
        button.setScale(0.90)
        button.run(scaleAnimation, completion: {
            
            switch button.buttonIdentifier! {
            case .Play:
                if !self.levelManager.curentLevel().locked {
                    self.sceneManager.scenePresentation(.game)
                }
            case .BrowseNextLevel:
                self.levelManager.slideNextLevel()
                self.updateCurentPresentLevel()
            case .BrowsePreviousLevel:
                self.levelManager.slidePreviousLevel()
                self.updateCurentPresentLevel()
            case .Close:
                self.stateMachine.enter(MenuSceneActiveState.self)
            case .Daltonism:
                let tempBool = self.sceneManager.option.bool(forKey: "Daltonism")
                self.sceneManager.option.set(!tempBool, forKey: "Daltonism")
                button.isActive = tempBool
            case .Settings:
                self.stateMachine.enter(MenuSceneSettingsState.self)
            case .MaskSelector:
                self.sceneManager.setColorMaskNumber(button.maskNumber!)
                self.sceneManager.loadColorMask(maskNumber: button.maskNumber!)
            case .Tutorial:
                self.sceneManager.scenePresentation(.tutorial)
            default:
                super.buttonTriggered(button)
            }
        })
    }
}
