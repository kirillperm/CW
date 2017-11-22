//
//  GameSceneOverlayState.swift
//  ColorWars
//
//  Created by Kirill Botalov on 10.07.16.
//  Copyright © 2016 Kirill Botalov. All rights reserved.
//

import SpriteKit
import GameplayKit

class SceneOverlayState: GKState {
    // MARK: Properties
    
    unowned let scene: BaseScene
    
    /// The `SceneOverlay` to display when the state is entered.
    var overlay: SceneOverlay!
    
    /// Overridden by subclasses to provide the name of the .sks file to load to show as an overlay.
    var overlaySceneFileName: String { fatalError("Unimplemented overlaySceneName") }
    
    // MARK: Initializers
    
    init(scene: BaseScene) {
        
        self.scene = scene
        
        super.init()
        
        overlay = SceneOverlay(overlaySceneFileName: overlaySceneFileName, zPosition: 1000)
    }
    
    // MARK: GKState Life Cycle
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        // Provide the levelScene with a reference to the overlay node.
        scene.overlay = overlay
    }
    
    override func willExit(to nextState: GKState) {
        super.willExit(to: nextState)

        scene.overlay = nil
    }
    
    // MARK: Convenience
    
    func buttonWithIdentifier(_ identifier: ButtonIdentifier) -> ButtonNode? {
        return overlay.contentNode.childNode(withName: "//\(identifier.rawValue)") as? ButtonNode
    }
}
