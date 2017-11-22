//
//  GameScenePauseState.swift
//  ColorWars
//
//  Created by Kirill Botalov on 10.07.16.
//  Copyright © 2016 Kirill Botalov. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScenePauseState: SceneOverlayState {
    // MARK: Properties
    
    override var overlaySceneFileName: String {
        return "PauseOverlay"
    }
    
    // MARK: GKState Life Cycle
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)

        scene.sceneIsPaused = true
        scene.gameTimer.pause = true
        
        #if FREE
            let backgroundOverlayNode = overlay.contentNode.childNode(withName: "BackgroundOverlay") as! SKSpriteNode
            let baner = overlay.contentNode.childNode(withName: "Baner") as! SKSpriteNode
            baner.texture = SKTexture(imageNamed: "Baner")
            baner.isHidden = false
            
            let positionBaner = (scene.size.height - backgroundOverlayNode.size.height) / 4
            baner.position.y = -(scene.size.height / 2) + positionBaner
        #else
            let baner = overlay.contentNode.childNode(withName: "Baner") as! SKSpriteNode
            baner.isHidden = true
        #endif
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is GameSceneActiveState.Type
    }
    
    override func willExit(to nextState: GKState) {
        super.willExit(to: nextState)
        
        scene.sceneIsPaused = false
        scene.gameTimer.pause = false
    }
}
