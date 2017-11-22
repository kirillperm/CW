//
//  TutorialScene.swift
//  ColorWars
//
//  Created by Kirill Botalov on 20.04.17.
//  Copyright © 2017 Kirill Botalov. All rights reserved.
//

import SpriteKit

class TutorialScene: BaseScene {
    
    var cellNodes: [CellNode] = []
    var buttonsColorSelector: [ButtonNode] = []
    
    var multiLabel: SKMultilineLabel?
    
    var gamePoleSprite = SKSpriteNode()
    
    var scoreBarSprite = SKSpriteNode()
    var timeNode = SKLabelNode()
    
    var textNode = ButtonNode()
    var continueNode = SKLabelNode()
    
    var arrowSprite = SKSpriteNode(imageNamed: "Arrow")
    var buttonsNode = SKSpriteNode()
    
    var game: Game!

    var scoreBarNode: ScoreBarNode!
    
    var animationCell = false
    
    var curentStep = -1

    enum arrowPosition {
        
        case Hidden
        case button
        case playerStartPosition
        case aiStartPosition
        case scoreBar
        case turn
    }
    
    // 0 - активность кнопок выбора цвета
    // 1 - цвет игрока при ходе
    // 2 - цвет компа при ходе
    // 3 - положение стрелки
    let step = [
/*000*/        [false, Color.Color1, Color.Color1, arrowPosition.Hidden],
/*001*/        [false, Color.Color1, Color.Color1, arrowPosition.Hidden],
/*002*/        [false, Color.Color1, Color.Color1, arrowPosition.Hidden],
/*010*/        [false, Color.Color1, Color.Color1, arrowPosition.playerStartPosition],
/*020*/        [false, Color.Color1, Color.Color1, arrowPosition.aiStartPosition],
/*030*/        [false, Color.Color1, Color.Color1, arrowPosition.button],
/*040*/        [false, Color.Color1, Color.Color1, arrowPosition.Hidden],
/*050*/        [false, Color.Color1, Color.Color1, arrowPosition.scoreBar],
/*000*/        [false, Color.Color1, Color.Color1, arrowPosition.Hidden],
/*060*/        [false, Color.Color1, Color.Color1, arrowPosition.Hidden],
/*061*/        [true , Color.Color3, Color.Color4, arrowPosition.turn],
/*070*/        [false, Color.Color1, Color.Color1, arrowPosition.Hidden],
/*071*/        [true , Color.Color5, Color.Color1, arrowPosition.turn],
/*080*/        [false, Color.Color1, Color.Color1, arrowPosition.Hidden],
/*081*/        [true , Color.Color2, Color.Color5, arrowPosition.turn],
/*090*/        [false, Color.Color1, Color.Color1, arrowPosition.scoreBar],
/*091*/        [false, Color.Color1, Color.Color1, arrowPosition.Hidden]
    ]
    
    let textForStep = [
/*000*/        NSLocalizedString("S1", comment: ""),
/*001*/        NSLocalizedString("S2", comment: ""),
/*002*/        NSLocalizedString("S3", comment: ""),
/*010*/        NSLocalizedString("S4", comment: ""),
/*020*/        NSLocalizedString("S5", comment: ""),
/*030*/        NSLocalizedString("S6", comment: ""),
/*040*/        NSLocalizedString("S7", comment: ""),
/*050*/        NSLocalizedString("S8", comment: ""),
/*051*/        NSLocalizedString("S9", comment: ""),
/*060*/        NSLocalizedString("S10", comment: ""),
/*061*/        NSLocalizedString("S11", comment: ""),
/*070*/        NSLocalizedString("S12", comment: ""),
/*071*/        NSLocalizedString("S13", comment: ""),
/*080*/        NSLocalizedString("S14", comment: ""),
/*081*/        NSLocalizedString("S15", comment: ""),
/*090*/        NSLocalizedString("S16", comment: ""),
/*091*/        NSLocalizedString("S17", comment: "")
    ]

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        sceneManager.loadColorMask(maskNumber: 0)

        buttonsColorSelector = findButtonsColorSelector()
        
        gamePoleSprite = childNode(withName: "//GamePole") as! SKSpriteNode
        
        //инициализация поля
        cellNodes = loadCell(background: gamePoleSprite, view: self.view!)

        game = Game(sizePole: cellNodes.count)
        
        scoreBarSprite = childNode(withName: "//ScoreBar") as! SKSpriteNode
        scoreBarNode = ScoreBarNode(game: game, scoreBarNode: scoreBarSprite)
        
        timeNode = childNode(withName: "//TimeNode") as! SKLabelNode
        
        //создание окошка с текстом
        let sizeTextNode = CGSize(width: gamePoleSprite.size.width * 0.8 ,
                                  height: cellNodes[123].size.height * 4.6)
        textNode = ButtonNode(color: SKColor.darkGray, size: sizeTextNode)
        textNode.buttonIdentifier = .Tutorial
        textNode.isUserInteractionEnabled = true
        textNode.position = CGPoint(x: 0, y: cellNodes[123].position.y - cellNodes[123].size.height / 3)
        textNode.zPosition = 10
        gamePoleSprite.addChild(textNode)
        
        continueNode = SKLabelNode(text: "Click to continue...")
        continueNode.fontName = "Andale Mono"
        continueNode.fontSize = 25
        continueNode.fontColor = SKColor.black
        continueNode.position = CGPoint(x: 0, y: -(textNode.size.height / 2) + 10)
        textNode.addChild(continueNode)
        
        multiLabel = SKMultilineLabel(text: "", labelWidth: Int(textNode.size.width - 10), pos: CGPoint(x: 0, y: (textNode.size.height / 2) + 0 ))
        multiLabel?.fontSize = textNode.size.height / 6
        multiLabel?.zPosition = 1
        textNode.addChild(multiLabel!)
        
        buttonsNode = childNode(withName: "//Button") as! SKSpriteNode
        buttonsNode.isHidden = true

        arrowSprite.position = CGPoint(x: 200, y: 200)
        arrowSprite.zPosition = 25
        arrowSprite.anchorPoint = CGPoint(x: 0.5, y: 1)

        let a1 = SKAction.init(named: "arrowAction")!
        let a2 = SKAction.repeatForever(a1)
        continueNode.run(a2)
        arrowSprite.run(a2)
        
        for player in game.players {
            
            let star = StartStar(isAi: player.ai)
            star.xScale = cellNodes[0].xScale
            star.yScale = cellNodes[0].yScale
            star.zPosition = cellNodes[0].zPosition + 0.1
            self.gamePoleSprite.addChild(star)
            startStar.append(star)
        }

        startTutorial()
    }
    
    func startTutorial() {
        
        sceneIsPaused = true
        
        let map = [238,239,244,245,266,268,272,274,295,296,301,302] //клетки вокруг стартовых
        game.startNewGame(player: 267, ai: 273, bonus: 0, map: map)
        game.countActiveCell = 19

        /*
         [296,297,298,299,300,301]
         [267,268,269,270,271,272,273]
         [239,240,241,242,243,244]
        */
        
        //заполнение поля блоками
        for i in 0..<cellNodes.count {
            cellNodes[i].colorCell = .Block
            game.pole[i] = .Block
        }
        
        //определение места player
        cellNodes[267].colorCell = .Color1
        game.pole[267] = .Color1
        game.players[0].clear(newCell: 267, color: .Color1)
        startStar[0].position = cellNodes[267].position

        //определение места ai
        cellNodes[273].colorCell = .Color2
        game.pole[273] = .Color2
        game.players[1].clear(newCell: 273, color: .Color2)
        startStar[1].position = cellNodes[273].position

        //рисование обучающего поля
        game.pole[239] = .Color3
        game.pole[240] = .Color3
        game.pole[272] = .Color1
        game.pole[301] = .Color4
        game.pole[296] = .Color4
        game.pole[268] = .Color4
        game.pole[244] = .Color4
        game.pole[300] = .Color5
        game.pole[271] = .Color5
        game.pole[243] = .Color5
        game.pole[241] = .Color5
        game.pole[297] = .Color6
        game.pole[269] = .Color6
        game.pole[298] = .Color2
        game.pole[299] = .Color2
        game.pole[270] = .Color2
        game.pole[242] = .Color7
        
        clearGamePole()
        updateGamePole()
        gameTimer.start()

        sceneIsPaused = false
        
        prezentStep()
    }
    
    func prezentStep() {
        
        //если нажата кнопка выбора цвета совершает ход
        if curentStep >= 0  && curentStep < step.count {
            if step[curentStep][0] as! Bool {
                game.nextMove(step[curentStep][1] as! Color)
                updateGamePole()
                game.nextMove(step[curentStep][2] as! Color)
                updateGamePole()
            }
        }
        
        if nextStep() {

            //изменение текста
            multiLabel?.text = textForStep[curentStep]

            //определение доступных для нажате кнопок
            if step[curentStep][0] as! Bool {
                textNode.isUserInteractionEnabled = false
                continueNode.isHidden = true
                for colorSelector in buttonsColorSelector {
                    if colorSelector.colorButton == step[curentStep][1] as? Color {
                        colorSelector.isUserInteractionEnabled = true
                    } else {
                        colorSelector.isUserInteractionEnabled = false
                    }
                }
            } else {
                textNode.isUserInteractionEnabled = true
                continueNode.isHidden = false
                for colorSelector in buttonsColorSelector {
                    colorSelector.isUserInteractionEnabled = false
                }
            }
            
            //размещение стрелки указателя
            arrowSprite.removeFromParent()
            buttonsNode.isHidden = true
            switch step[curentStep][3] as! arrowPosition {
            case .Hidden:
                break
            case .playerStartPosition:
                gamePoleSprite.addChild(arrowSprite)
                arrowSprite.position = cellNodes[game.players[0].start].position
                arrowSprite.position.x -= cellNodes[game.players[0].start].size.width / 2
                arrowSprite.zRotation = -2
            case.aiStartPosition:
                gamePoleSprite.addChild(arrowSprite)
                arrowSprite.position = cellNodes[game.players[1].start].position
                arrowSprite.position.x += cellNodes[game.players[0].start].size.width / 2
                arrowSprite.zRotation = 2
            case .button:
                buttonsNode.addChild(arrowSprite)
                arrowSprite.position = CGPoint(x: -(buttonsNode.size.width / 2) - 2 , y: 0)
                arrowSprite.zRotation = -2
                buttonsNode.isHidden = false
            case .scoreBar:
                scoreBarNode.scoreBarNode.addChild(arrowSprite)
                arrowSprite.position = CGPoint(x: 0, y: 0 - scoreBarNode.scoreBarNode.size.height / 2)
                arrowSprite.zRotation = -0.8
            case .turn:
                for i in buttonsColorSelector {
                    if i.colorButton == step[curentStep][1] as? Color {
                        i.addChild(arrowSprite)
                    }
                }
                arrowSprite.position = CGPoint(x: 0, y: 0)
                arrowSprite.zRotation = -2
            }
        }
    }
    
    func nextStep() -> Bool {
        
        curentStep += 1
        if curentStep == step.count {
            endTutorial()
            return false
        }
        return true
    }
    
    func endTutorial() {
        
        self.sceneManager.scenePresentation(.menu)
    }

    override func update(_ currentTime: TimeInterval) {
        
        gameTimer.update(curentTime: currentTime)
        timeNode.text = gameTimer.getCurentTime()
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
                colorSelectorNumber += 1
            }
        }
    }
}
