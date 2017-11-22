//
//  Player.swift
//  ColorWars
//
//  Created by Kirill Botalov on 22.06.16.
//  Copyright © 2016 Kirill Botalov. All rights reserved.
//

struct Cell {

    var border: [Int]
    var inside: [Int]
    
    var all: [Int]
    
    init(border: [Int], inside: [Int]) {
        self.border = border
        self.inside = inside
        
        self.all = border + inside
    }
}

class Player {

    var ai: Bool
    var color: Color = .Block
    var start = -1
    var cell = Cell(border: [], inside: []) {
        //проверка нулевых ходов
        didSet {
            if oldValue.all.count == cell.all.count {
                nilTurnCounter += 1
            } else {
                nilTurnCounter = 0
            }
        }
    }
    
    var nilTurnCounter = 0

    init(ai: Bool) {
        
        self.ai = ai
    }
    
    func clear(newCell: Int, color: Color) {
        
        self.nilTurnCounter = 0
        self.start = newCell
        self.cell = Cell(border: [newCell], inside: [])
        self.color = color
    }
}
