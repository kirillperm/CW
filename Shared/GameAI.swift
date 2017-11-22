//
//  GameAI.swift
//  ColorWars
//
//  Created by Kirill Botalov on 14.07.16.
//  Copyright © 2016 Kirill Botalov. All rights reserved.
//

extension Game {

    func turnAI() -> Color {

        //ход с максимальным колличеством очков
        var bestTurnColor: Color = .Block
        var bestTurnScore = -1
        var bestTurn = -1
        
        var turn1pole: [[Color]] = []
        var turn1aiCell: [Cell] = []

        //запалнение масива первого хода
        for color in Color.arrayColor {
            if validationPlayerTurn(color) {
                let calcMoveTurn1 = calcMove(ai: true, newColor: color, inPole: pole, inCell: players[1].cell)
                turn1pole.append(calcMoveTurn1.outPole)
                turn1aiCell.append(calcMoveTurn1.outCell)
            }
        }

        for i in 0..<turn1pole.count {
            
            for color in Color.arrayColor {

                let calcMoveAi = calcMove(ai: true, newColor: color, inPole: turn1pole[i], inCell: turn1aiCell[i])
                
                if calcMoveAi.outCell.all.count > bestTurnScore {
                    bestTurnScore = calcMoveAi.outCell.all.count
                    bestTurnColor = turn1pole[i][players[1].start]
                    bestTurn = i
                }
            }
        }

        //зашита от нулевых ходов
        //----------------------------------не проверена работа
        if players[0].nilTurnCounter == 1 &&
            turn1aiCell[bestTurn].all.count == players[1].cell.all.count {
            
            for i in 0..<turn1pole.count {
                if turn1aiCell[i].all.count > players[1].cell.all.count {
                    bestTurnColor = turn1pole[i][players[1].start]
                }
            }
        }

        return(bestTurnColor)
    }
}
