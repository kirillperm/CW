//
//  GameSceneWinState.swift
//  ColorWars
//
//  Created by Kirill Botalov on 19.07.16.
//  Copyright © 2016 Kirill Botalov. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameSceneWinState: SceneOverlayState {
    // MARK: Properties

    override var overlaySceneFileName: String {
        return "WinOverlay"
    }

    let gameScene: GameScene
    
    override init(scene: BaseScene) {

        self.gameScene = scene as! GameScene

        super.init(scene: scene)
    }
    
    // MARK: GKState Life Cycle
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)

        scene.sceneIsPaused = true
        scene.gameTimer.pause = true

        let recordLabel = gameScene.childNode(withName: "//RecordLabel") as? SKLabelNode

        recordLabel?.isHidden = true

        //обновление информаций об уровне в случае победы
        let newRecord = gameScene.levelManager.updateLevel(newTurn: gameScene.game.turnCounter)
        
        if newRecord { //анимация звезды
            
            recordLabel?.text = NSLocalizedString("NewRecord", comment: "") + String(gameScene.game.turnCounter)
            
            let winEmitter = SKEmitterNode(fileNamed: "WinGame")
            winEmitter?.zPosition = recordLabel!.zPosition - 0.1
            winEmitter?.position = recordLabel!.position
            scene.overlay?.backgroundNode.addChild(winEmitter!)

            recordLabel?.setScale(3)
            
            let a0 = SKAction.scale(to: 1, duration: 1)
            let a1 = SKAction.init(named: "arrowAction")!
            let a2 = SKAction.repeatForever(a1)
            
            recordLabel?.isHidden = false
            recordLabel?.run(a0, completion: {
                winEmitter?.numParticlesToEmit = 60
                recordLabel?.run(a2)
                recordLabel?.isHidden = false
            })
        }
        
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
