//
//  ScoreBarNode.swift
//  ColorWars
//
//  Created by Kirill Botalov on 05.07.16.
//  Copyright © 2016 Kirill Botalov. All rights reserved.
//

import SpriteKit

class ScoreBarNode {
    
    let game: Game
    let scoreBarNode: SKSpriteNode
    
    let scoreBarFullSize: CGFloat

    let minSizePlayerScore: CGFloat = 20
    
    var turnNode = SKLabelNode()

    var playerColorNode: [SKSpriteNode] = []

    init(game: Game, scoreBarNode: SKSpriteNode ) {
        
        self.game = game
        self.scoreBarNode = scoreBarNode

        turnNode = scoreBarNode.childNode(withName: "//TurnNode") as! SKLabelNode

        for countPlayer in 0..<game.players.count {
            
            let playerColor = self.scoreBarNode.childNode(withName: "playerColor\(countPlayer)") as? SKSpriteNode
            playerColorNode.append(playerColor!)
        }

        //вычитание из общей длины центра, для более точного расчета длины полосок
        let scoreBarCenter = scoreBarNode.childNode(withName: "//CenterBorder") as? SKSpriteNode
        
        scoreBarFullSize = scoreBarNode.size.width - minSizePlayerScore * 2 - (scoreBarCenter?.size.width)!
    }
    
    func updateScoteBar() {
        
        let scoreBarCellSize = scoreBarFullSize / CGFloat(game.countActiveCell)
        
        turnNode.text = String(game.turnCounter)
        
        for playerNumber in 0..<game.players.count {
            
            let score = game.players[playerNumber].cell.all.count

            let color = Color.SKColorValue[game.players[playerNumber].color]
            playerColorNode[playerNumber].color = color!
            
            let size = CGFloat(score) * scoreBarCellSize
            playerColorNode[playerNumber].size.width = size + minSizePlayerScore
        }
    }
}
