//
//  MenuScene.swift
//  ColorWars
//
//  Created by Kirill Botalov on 17.06.16.
//  Copyright © 2016 Kirill Botalov. All rights reserved.
//

import SpriteKit
import GameplayKit

class MenuScene: BaseScene {

    var levelPreviewNode = SKSpriteNode()
    var LevelPreviewShadowNode = SKSpriteNode()
    var lockedNode = SKSpriteNode()
    var playNode = SKSpriteNode()
    var recordLabel = SKLabelNode()
    var levelCounterLabel = SKLabelNode()

    lazy var stateMachine: GKStateMachine = GKStateMachine(states: [
        MenuSceneActiveState(scene: self),
        MenuSceneSettingsState(scene: self)
        ])
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        sceneManager.loadColorMask(maskNumber: 0)
        
        lockedNode = childNode(withName: "//Locked") as! SKSpriteNode
        playNode = childNode(withName: "//Play") as! SKSpriteNode

        recordLabel = childNode(withName: "//RecordLabel") as! SKLabelNode
        levelCounterLabel = childNode(withName: "//LevelCounterLabel") as! SKLabelNode
        
        levelPreviewNode = childNode(withName: "//LevelPreview") as! SKSpriteNode
        LevelPreviewShadowNode = childNode(withName: "//LevelPreviewShadow") as! SKSpriteNode

        createLevelPreview()
        
        levelPreviewNode.texture = levelManager.curentLevel().texturePreview
        updateCurentPresentLevel()
        
        //проверка для загрузки обучения
        if self.sceneManager.tutorial == true {
            self.sceneManager.tutorial = false
            sceneManager.scenePresentation(.tutorial)
        }

        stateMachine.enter(GameSceneActiveState.self)
    }
    
    func createLevelPreview() {

        let background = SKSpriteNode(color: SKColor.black, size: levelPreviewNode.size)

        var cellNodes = loadCell(background: background, view: self.view!)

        for level in levelManager.levels {
            //очистка cellPole
            for index in 0..<cellNodes.count {
                cellNodes[index].color = Color.SKColorValue[Color.random()]!
            }
            //загрузка уровня
            for block in level.map! {
                cellNodes[block].color = SKColor.black
            }
            //создание levelPreview
            let textureForPreview = (self.view?.texture(from: background))!
            level.texturePreview = textureForPreview
        }
    }

    func updateCurentPresentLevel() {
        levelCounterLabel.text = ("\(levelManager.curentLevel().index + 1) - \(levelManager.levels.count)")
        
        lockedNode.isHidden = !(levelManager.curentLevel().locked)
        LevelPreviewShadowNode.isHidden = !(levelManager.curentLevel().locked)
        playNode.isHidden = levelManager.curentLevel().locked
        
        if levelManager.curentLevel().getTurn() == 99999 {
            recordLabel.isHidden = true
        } else {
            recordLabel.isHidden = false
            let recordString = NSLocalizedString("Record", comment: "")
            let turnCountString = String(levelManager.curentLevel().getTurn())
            recordLabel.text = recordString + turnCountString
        }
        
        levelPreviewNode.texture = levelManager.curentLevel().texturePreview
    }
    
    override func update(_ currentTime: TimeInterval) {
        self.stateMachine.update(deltaTime: currentTime)
    }
}
