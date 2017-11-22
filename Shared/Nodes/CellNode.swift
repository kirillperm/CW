//
//  CellNodes.swift
//  ColorWars
//
//  Created by Kirill Botalov on 18.06.16.
//  Copyright © 2016 Kirill Botalov. All rights reserved.
//

import SpriteKit
import GameplayKit

enum Color: String {
    //@#%$+=!
    case Tech = " "
    case cellCurentPlayer = "  "
    case cellOtherPlayer = "   "
    case Block = "    "
    case Color1 = "!"
    case Color2 = "+"
    case Color3 = "="
    case Color4 = "#"
    case Color5 = "%"
    case Color6 = "$"
    case Color7 = "@"
    
    static var SKColorValue = [
        Color.Block: SKColor.black,
    ]
    
    static let ColorMask = [ //darkgray purple
        [   //стандартная
            Color.Block: SKColor.black,
            Color.Color1: SKColor.white,
            Color.Color2: SKColor.blue,
            Color.Color3: SKColor.yellow,
            Color.Color4: SKColor.init(red: 0, green: 0.45, blue: 0, alpha: 1), //зеленый
            Color.Color5: SKColor.red,
            Color.Color6: SKColor.init(red: 1, green: 0.6, blue: 0.1, alpha: 1), //оранжевый
            Color.Color7: SKColor.gray
        ],
        [   //дальтоников
            Color.Block: SKColor.black,
            Color.Color1: SKColor.white,
            Color.Color2: SKColor.blue,
            Color.Color3: SKColor.yellow,
            Color.Color4: SKColor.init(red: 0, green: 0.45, blue: 0, alpha: 1), //зеленый
            Color.Color5: SKColor.init(red: 0.8, green: 0.8, blue: 0.8, alpha: 1), //светлосерый
            Color.Color6: SKColor.init(red: 1, green: 0.6, blue: 0.1, alpha: 1), //оранжевый
            Color.Color7: SKColor.init(red: 0.45, green: 0.45, blue: 0.45, alpha: 1) //темно серый
        ],
        [   //альтернативная
            Color.Block: SKColor.black,
            Color.Color1: SKColor.white,
            Color.Color2: SKColor.blue,
            Color.Color3: SKColor.yellow,
            Color.Color4: SKColor.init(red: 0.8, green: 0.8, blue: 0.8, alpha: 1), //светлосерый
            Color.Color5: SKColor.red,
            Color.Color6: SKColor.init(red: 1, green: 0.6, blue: 0.1, alpha: 1), //оранжевый
            Color.Color7: SKColor.init(red: 0.45, green: 0.45, blue: 0.45, alpha: 1) //темно серый
        ]
    ]

    static let randomColor = GKShuffledDistribution(randomSource: GKARC4RandomSource(), lowestValue: 0, highestValue: 6) //генератор случайного цвета

    static let arrayColor: [Color] = [ .Color1, .Color2, .Color3, .Color4, .Color5, .Color6, .Color7 ]
    
    static func random() -> Color {
        
        return arrayColor[randomColor.nextInt()]
    }
}

class CellNode: SKSpriteNode {
    
    var text = SKLabelNode(fontNamed: "Andale Mono")
    
    var background = SKSpriteNode()
    
    var animation = false
    
    var colorCell = Color.Block {
        willSet(newColor) {

            text.text = newColor.rawValue

            if animation {
                self.color = SKColor.black
                self.background.color = SKColor.black
                let animationColor = SKAction.colorize(with: Color.SKColorValue[newColor]!, colorBlendFactor: 1, duration: 0.1)
                self.background.run(animationColor)
                self.run(animationColor)
            } else {
                self.color = Color.SKColorValue[newColor]!
                self.background.color = Color.SKColorValue[newColor]!
            }
        }
    }
    
    override init(texture: SKTexture?, color: SKColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    init(view: SKView) {
        
        let spriteFromCell = view.texture(from: ShapeNodeFromCell(backgrounde: false))!
        let spriteFromCellBackgrounde = view.texture(from: ShapeNodeFromCell(backgrounde: true))!

        super.init(texture: spriteFromCell, color: SKColor.white, size: spriteFromCell.size())
        
        self.colorBlendFactor = 1
        self.zPosition = 1

        text.fontColor = SKColor.black
        text.fontSize = 26
        text.zPosition = 11
        text.position = CGPoint(x: 0 , y: -10)
        text.isHidden = true
        self.addChild(text)
        
        background = SKSpriteNode(texture: spriteFromCellBackgrounde)
        background.zPosition = -0.5
        background.setScale(1.2)
        background.colorBlendFactor = 1
        background.isHidden = true
        self.addChild(background)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func copy() -> Any {
        let newCell = super.copy() as! CellNode
        
        newCell.text = self.text.copy() as! SKLabelNode
        newCell.addChild(newCell.text)
        
        newCell.background = self.background.copy() as! SKSpriteNode
        newCell.addChild(newCell.background)

        return newCell
    }
}

class ShapeNodeFromCell: SKShapeNode {

    init(backgrounde: Bool) {
        
        let path = CGMutablePath()

        let texture = SKTexture(imageNamed: "CellSprite")
        let size = texture.size()
        
        path.move(to: CGPoint(x: size.width / 2, y: 0.0 ) )
        path.addLine(to: CGPoint(x: size.width, y: size.height / 3 ) )
        path.addLine(to: CGPoint(x: size.width, y: size.height / 3 * 2 ) )
        path.addLine(to: CGPoint(x: size.width / 2, y: size.height) )
        path.addLine(to: CGPoint(x: 0, y: size.height / 3 * 2 ) )
        path.addLine(to: CGPoint(x: 0, y: size.height / 3 ) )
        path.addLine(to: CGPoint(x: size.width / 2, y: 0.0 ) )
        
        super.init()
        
        self.path = path
        self.fillColor = SKColor.white
        
        if !backgrounde {
            self.strokeColor = SKColor.black
            self.lineWidth = 3
        }
        
        self.fillTexture = texture
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


func loadCell(background: SKSpriteNode, view: SKView) -> [CellNode] {
    
    var cells: [CellNode] = []
    //создание образцовой клетки
    let baseCell = CellNode(view: view)
    //колличество гексов в строке
    var countX: Int
    //левый ныжний угол(старовая позиция отсчета положения клеток)
    let startPoint = CGPoint.init(x: -(background.size.width / 2 - 3), y: -(background.size.height / 2 - 8))

    //вычесление масштабировани клетки и назначение масштабирования клетки
    let xScale = (background.size.width - 6) / (baseCell.size.width * CGFloat(GameConfig.poleSizeX + 1))
    let yScale = (background.size.height - 16) / (baseCell.size.height * CGFloat((GameConfig.poleSizeY + 8) / 2))
    baseCell.xScale = xScale
    baseCell.yScale = yScale
    
    //базовое смещение клетки
    let offsetXbase = baseCell.size.width / 2
    let offsetYbase = baseCell.size.height / 2
    var offsetX: CGFloat = 0
    var offsetY: CGFloat = 0
    
    //для удобства формулы
    let cW = baseCell.size.width
    let cH = baseCell.size.height

    for y in 0..<GameConfig.poleSizeY {
        
        if  y % 2 == 0 { //проверка четной строки
            offsetX = offsetXbase + cW / 2
            countX = GameConfig.poleSizeX
        } else {
            offsetX = offsetXbase
            countX = GameConfig.poleSizeX + 1
        }
        
        offsetY = CGFloat(y) * (cH * 0.33)
        
        for x in 0..<countX {

            let cell = baseCell.copy() as! CellNode
            
            let xPosition = startPoint.x + offsetX + (CGFloat(x) * cW)
            let yPosition = startPoint.y + offsetYbase - offsetY + (CGFloat(y) * cH)
            cell.position = CGPoint(x: xPosition, y: yPosition)

            background.addChild(cell)
            cells.append(cell)
        }
    }
    
    return cells
}


