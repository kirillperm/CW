//
//  GameScene.swift
//  ColorWars
//
//  Created by Kirill Botalov on 17.06.16.
//  Copyright © 2016 Kirill Botalov. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: BaseScene {
    
    var cellNodes: [CellNode] = []
    var buttonsColorSelector: [ButtonNode] = []
    
    var gamePoleSprite = SKSpriteNode()

    var timeNode = SKLabelNode()

    var game: Game!

    var scoreBarNode: ScoreBarNode!
    
    var animationCell = false
    
    lazy var stateMachine: GKStateMachine = GKStateMachine(states: [
        GameSceneActiveState(scene: self),
        GameScenePauseState(scene: self),
        GameSceneFeilState(scene: self),
        GameSceneWinState(scene: self)
        ])
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        sceneManager.loadColorMask(maskNumber: sceneManager.getColorMaskNumber())
        
        //костыль скрытия подсветки кнопок
        let buttonsNode = childNode(withName: "//Button") as! SKSpriteNode
        buttonsNode.isHidden = true

        buttonsColorSelector = findButtonsColorSelector()

        gamePoleSprite = childNode(withName: "//GamePole") as! SKSpriteNode

        //инициализация поля
        cellNodes = loadCell(background: gamePoleSprite, view: self.view!)
        
        //включение режима дальтоника
        if daltonism {
            for cell in cellNodes {
                cell.text.isHidden = false
            }
        }

        game = Game(sizePole: cellNodes.count)
        
        let scoreBarSprite = childNode(withName: "//ScoreBar") as! SKSpriteNode
        scoreBarNode = ScoreBarNode(game: game, scoreBarNode: scoreBarSprite)
        
        timeNode = childNode(withName: "//TimeNode") as! SKLabelNode
        
        for player in game.players {

            let star = StartStar(isAi: player.ai)
            star.xScale = cellNodes[0].xScale
            star.yScale = cellNodes[0].yScale
            star.zPosition = cellNodes[0].zPosition + 0.5
            self.gamePoleSprite.addChild(star)
            startStar.append(star)
        }
        
        startGame()
    }
    
    func startGame() {
        
        stateMachine.enter(GameSceneActiveState.self)
        
        sceneIsPaused = true
        gameTimer.stop()

        let level = levelManager.curentLevel()
        game.startNewGame(player: level.getPlayer(), ai: level.getAI(), bonus: level.getBonus(), map: level.map!)

        animationCell = false
        clearGamePole()
        updateGamePole()

        let oldZ = startStar[0].zPosition
        startStar[0].isHidden = true
        startStar[1].isHidden = true
        startStar[0].zPosition += 1
        startStar[1].zPosition += 1
        DispatchQueue.global().async {
            self.startStar[0].animationStartStar(endPosition: self.cellNodes[self.game.players[0].start].position)
            while self.startStar[0].hasActions(){}
            self.startStar[0].zPosition = oldZ
            
            DispatchQueue.global().async {
                self.startStar[1].animationStartStar(endPosition: self.cellNodes[self.game.players[1].start].position)
                while self.startStar[1].hasActions(){}
                self.startStar[1].zPosition = oldZ
                DispatchQueue.main.async {
                    self.sceneIsPaused = false
                    self.gameTimer.start()
                    self.animationCell = true
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        gameTimer.update(curentTime: currentTime)
        timeNode.text = gameTimer.getCurentTime()
    }
    
    override func enterBackgrounde() {
        self.stateMachine.enter(GameScenePauseState.self)
    }
    
    func turn(color: Color) {

        sceneIsPaused = true
        DispatchQueue.global().async {
            //подсчет и выполнение хода player
            self.game.nextMove(color)
            //подсчет и выполнение хода ai
            self.game.nextMove(self.game.turnAI())
            
            self.updateGamePole()

            DispatchQueue.global().async {
                self.checkWinGame()
                self.sceneIsPaused = false
            }
        }
    }
    
    func checkWinGame() {
        //проверка победы
        if let checkWin = game.checkWin() {
            if checkWin {
                stateMachine.enter(GameSceneWinState.self)
            } else {
                stateMachine.enter(GameSceneFeilState.self)
            }
        }
    }

    func updateGamePole() {

        syncPlayersCell(player: 0)
        syncPlayersCell(player: 1)
        updateColorSelector()
        scoreBarNode.updateScoteBar()
    }

    func syncPlayersCell(player: Int) {
        
        let newColor = game.players[player].color
        
        for cell in game.players[player].cell.all {
            cellNodes[cell].animation = animationCell
            cellNodes[cell].colorCell = newColor
            cellNodes[cell].background.isHidden = false
        }
    }
    
    func clearGamePole() {
        
        for i in 0..<cellNodes.count {
            cellNodes[i].colorCell = game.pole[i]
            cellNodes[i].background.isHidden = true
        }
    }
    
    //обновление кнопок выбора цвета
    func updateColorSelector() {
        
        var colorSelectorNumber = 0
        for color in Color.arrayColor {
            
            if color != game.players[0].color && color != game.players[1].color {
                
                buttonsColorSelector[colorSelectorNumber].colorButton = color
                if buttonsColorSelector[colorSelectorNumber].text != nil {
                    buttonsColorSelector[colorSelectorNumber].text?.text = color.rawValue }
                colorSelectorNumber += 1
            }
        }
    }
}
