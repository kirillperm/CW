//
//  CellPole.swift
//  ColorWars
//
//  Created by Kirill Botalov on 24.06.16.
//  Copyright © 2016 Kirill Botalov. All rights reserved.
//

import SpriteKit

struct GameConfig {
    //pole scale
    static let poleSizeX = 28 //размер поля. строки.
    static let poleSizeY = 19 //размер поля. колонки. нечетное
}

class Game {
    var pole: [Color] = []
    var countActiveCell = 0
    
    var players: [Player] = []
    var currentPlayerNumber = 0

    var turnCounter = 1
    var passTurnCheck = false //пропуск первой проверки цветов для хода
    
    init(sizePole: Int) {
        //init pole
        for _ in 0..<sizePole {
            pole.append(Color.Block)
        }

        //init playrs
        players.append(Player(ai: false))
        players.append(Player(ai: true))
    }
    
    func startNewGame(player: Int, ai: Int, bonus: Int, map: [Int]) {

        //очистка поля
        for indexCell in 0..<pole.count {
            pole[indexCell] = Color.random()
        }
        //загрузка уровня
        for blockCell in map {
            pole[blockCell] = .Block
        }
        
        countActiveCell = pole.count - map.count

        //проверка чтоб были разные цвета игроков
        while pole[player] == pole[ai] {
            pole[player] = Color.random()
        }
        
        //обнуление данных игроков
        players[0].clear(newCell: player, color: pole[player])
        players[1].clear(newCell: ai, color: pole[ai])
        
        passTurnCheck = true
        currentPlayerNumber = 0
        nextMove(players[0].color)
        currentPlayerNumber = 1
        nextMove(players[1].color)
        passTurnCheck = false

        //проведение бонусных ходов ai
        for _ in 0..<bonus {
            currentPlayerNumber = 1
            nextMove(turnAI())
        }

        players[0].nilTurnCounter = 0
        players[1].nilTurnCounter = 0
        currentPlayerNumber = 0
        turnCounter = 1
    }
    
    func checkWin() -> Bool? {
        
        var check: Bool?
        
        if players[0].nilTurnCounter > 1 {
            if chechNilTurnPlayer() {
                return false
            }
        }
        if players[1].nilTurnCounter > 1 {
            return true
        }

        if players[0].cell.all.count >= countActiveCell / 2 {
            check = true
        } else if players[1].cell.all.count >= countActiveCell / 2 {
            check = false
        }

        return check
    }
    
    func chechNilTurnPlayer() -> Bool {
        
        for color in Color.arrayColor {
            
            if color == players[0].color {
                continue
            }
            
            if calcMove(ai: false, newColor: color, inPole: pole, inCell: players[0].cell).outCell.all.count > players[0].cell.all.count {
                return false
            }
        }

        return true
    }
    
    func nextMove(_ color: Color) {
        
        if validationPlayerTurn(color) {
            
            let move = calcMove(ai: curentPlayerIsAI(), newColor: color, inPole: pole, inCell: players[currentPlayerNumber].cell)
            
            pole = move.outPole
            players[currentPlayerNumber].color = color
            players[currentPlayerNumber].cell = move.outCell
            
            if currentPlayerNumber == 0 {
                turnCounter += 1
            }

            nextPlayer()
        }
    }
    
    func nextPlayer(){
        
        currentPlayerNumber += 1
        
        if currentPlayerNumber >= players.count {
            currentPlayerNumber = 0
        }
    }
    
    func curentPlayerIsAI() -> Bool {
        
        return players[currentPlayerNumber].ai
    }
    
    func validationPlayerTurn(_ checkColor: Color) -> Bool {
        
        if passTurnCheck { return true }
        
        for player in players {
            if player.color == checkColor {
                return false
            }
        }
        return true
    }
}
