//
//  SceneManager.swift
//  ColorWars
//
//  Created by Kirill Botalov on 17.06.16.
//  Copyright © 2016 Kirill Botalov. All rights reserved.
//

import SpriteKit

final class SceneManager {
    
    let skView: SKView
    let levelManager: LevelManager
    
    let option: UserDefaults
    
    weak var scene: BaseScene!
    
    var tutorial = false

    enum SceneIdentifier {
        case menu
        case game
        case tutorial
    }
    
    let menuSceneName: String
    let gameSceneName: String

    init(skView: SKView) {
        self.option = UserDefaults.standard

        if option.object(forKey: "ColorMask") == nil {
            self.option.set(0, forKey: "ColorMask")
            self.option.set(false, forKey: "Daltonism")
            
            tutorial = true
        }

        self.skView = skView
        
        //определение размера сцены
        #if os(OSX)
            self.menuSceneName = "MenuScene"
            self.gameSceneName = "GameScene"
        #else
            switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                self.menuSceneName = "MenuScene-iPhone"
                self.gameSceneName = "GameScene-iPhone"
            case .pad:
                self.menuSceneName = "MenuScene-iPad"
                self.gameSceneName = "GameScene-iPad"
            default:
                self.menuSceneName = "MenuScene-iPhone"
                self.gameSceneName = "GameScene-iPhone"
            }
        #endif

        self.levelManager = LevelManager()
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        self.skView.ignoresSiblingOrder = true

        #if debug
            self.skView.showsFPS = true
            self.skView.showsNodeCount = true
        #endif
    }

    func getColorMaskNumber() -> Int {
        return self.option.integer(forKey: "ColorMask")
    }
    
    func setColorMaskNumber(_ mask: Int) {
        self.option.set(mask, forKey: "ColorMask")
    }
    
    func loadColorMask(maskNumber: Int) {
        Color.SKColorValue = Color.ColorMask[maskNumber]
    }
    
    func scenePresentation(_ sceneIdentifier: SceneIdentifier) {
        switch sceneIdentifier {
        case .menu:
            scene = MenuScene(fileNamed: menuSceneName)!
        case .game:
            scene = GameScene(fileNamed: gameSceneName)!
        case .tutorial:
            scene = TutorialScene(fileNamed: gameSceneName)!
        }
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .aspectFill
        scene.sceneManager = self
        scene.levelManager = levelManager
        self.skView.presentScene(scene)
    }
}
