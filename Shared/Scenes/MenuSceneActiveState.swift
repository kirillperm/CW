//
//  MenuSceneActiveState.swift
//  ColorWars
//
//  Created by Kirill Botalov on 08.08.16.
//  Copyright © 2016 Kirill Botalov. All rights reserved.
//

import SpriteKit
import GameplayKit

class MenuSceneActiveState: GKState {
    // MARK: Properties
    
    unowned let scene: BaseScene
    
    // MARK: Initializers
    
    init(scene: BaseScene) {
        self.scene = scene
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is MenuSceneSettingsState.Type :
            return true
        default:
            return false
            
        }
    }
}
