//
//  BaseScene.swift
//  ColorWars
//
//  Created by Kirill Botalov on 17.06.16.
//  Copyright © 2016 Kirill Botalov. All rights reserved.
//

import SpriteKit

class BaseScene: SKScene {
    
    weak var sceneManager: SceneManager!
    weak var levelManager: LevelManager!

    var buttons = [ButtonNode]()
    
    var startStar: [StartStar] = []

    var sceneIsPaused = false
    
    let gameTimer = GameTimer()
    
    var daltonism = false

    /// The current scene overlay (if any) that is displayed over this scene.
    var overlay: SceneOverlay? {
        didSet {
            // Clear the `buttons` in preparation for new buttons in the overlay.
            buttons = []

            if let overlay = overlay, let camera = camera {
                overlay.backgroundNode.removeFromParent()
                camera.addChild(overlay.backgroundNode)
                
                //Animate the overlay in.
                overlay.backgroundNode.alpha = 0.0
                overlay.backgroundNode.run(SKAction.fadeIn(withDuration: 0.15))
                
                buttons = findAllButtonsInScene()
            }
            //Animate the old overlay out.
            oldValue?.backgroundNode.run(SKAction.fadeOut(withDuration: 0.15), completion: {
                oldValue?.backgroundNode.removeFromParent()
            }) 
        }
    }
    
    func enterBackgrounde() {}
    
    func returnBackgrounde() {}
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        self.scaleMode = SKSceneScaleMode.fill
        
        self.daltonism = self.sceneManager.option.bool(forKey: "Daltonism")

        buttons = findAllButtonsInScene()
    }
}
