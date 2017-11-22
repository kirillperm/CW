//
//  MenuSceneSettingsState.swift
//  ColorWars
//
//  Created by Kirill Botalov on 26.09.16.
//  Copyright © 2016 Kirill Botalov. All rights reserved.
//

import SpriteKit
import GameplayKit

class MenuSceneSettingsState: SceneOverlayState {
    // MARK: Properties
    
    var daltonismButton: ButtonNode?
    
    override var overlaySceneFileName: String {
        return "SettingsOverlay"
    }
    
    var maskSelectorArray = [ButtonNode]()
    
    // MARK: GKState Life Cycle
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)

        scene.sceneIsPaused = true
        
        for findDaltonismButton in self.scene.buttons {
            if findDaltonismButton.buttonIdentifier == .Daltonism {
                daltonismButton = findDaltonismButton }
        }

        var mask = 0
        let backgroundOverlayNode = overlay.contentNode.childNode(withName: "BackgroundOverlay") as! SKSpriteNode
        
        #if FREE
            let baner = overlay.contentNode.childNode(withName: "Baner") as! SKSpriteNode
            baner.texture = SKTexture(imageNamed: "Baner")
            baner.isHidden = false
            
            let positionBaner = (scene.size.height - backgroundOverlayNode.size.height) / 4
            baner.position.y = -(scene.size.height / 2) + positionBaner
        #else
            let baner = overlay.contentNode.childNode(withName: "Baner") as! SKSpriteNode
            baner.isHidden = true
        #endif

        for children in backgroundOverlayNode.children {

            if children.name == "BackgroundMask" {

                let maskSelectorNode = children.childNode(withName: "MaskSelector") as! ButtonNode

                maskSelectorNode.maskNumber = mask
                
                var colorNodeArray = [SKSpriteNode]() //раскраска цветов внутри селектора
                for colorChildren in maskSelectorNode.children {
                    if colorChildren.name == "Color" {
                        colorNodeArray.append(colorChildren as! SKSpriteNode) }
                }

                var index = 0
                for color in Color.ColorMask[mask] {
                    if color.key == .Block { continue }
                    colorNodeArray[index].color = color.1
                    index += 1
                }

                maskSelectorArray.append(maskSelectorNode)
                mask += 1
            }
        }

    }

    override func update(deltaTime seconds: TimeInterval) {

        for maskSelector in maskSelectorArray {
            
            if maskSelector.maskNumber == scene.sceneManager.getColorMaskNumber() {
                maskSelector.isActive = false
            } else {
                maskSelector.isActive = true
            }
        }
        
        daltonismButton!.isActive = !(self.scene.sceneManager.option.bool(forKey: "Daltonism"))
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is MenuSceneActiveState.Type
    }
    
    override func willExit(to nextState: GKState) {
        super.willExit(to: nextState)
        
        maskSelectorArray = []
        scene.sceneIsPaused = false
    }
}
