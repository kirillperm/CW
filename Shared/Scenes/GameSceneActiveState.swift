//
//  GameSceneActiveState.swift
//  ColorWars
//
//  Created by Kirill Botalov on 10.07.16.
//  Copyright © 2016 Kirill Botalov. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameSceneActiveState: GKState {
    // MARK: Properties
    
    unowned let scene: BaseScene
    
    // MARK: Initializers
    
    init(scene: BaseScene) {
        self.scene = scene
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is GameScenePauseState.Type, is GameSceneFeilState.Type, is GameSceneWinState.Type:
            return true   
        default:
            return false
        }
    }
}
