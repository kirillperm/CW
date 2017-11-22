//
//  GameTimer.swift
//  ColorWars
//
//  Created by Kirill Botalov on 26.06.17.
//  Copyright © 2016 Kirill Botalov. All rights reserved.
//

import Foundation

class GameTimer {
    
    var pause = false
    
    var oldTime: Double = 0
    var time: Double = 0
    
    func start() {
        
        pause = false
    }

    func stop() {
        
        pause = true
        
        oldTime = 0
        time = 0
    }
    
    func update (curentTime: TimeInterval) {
        
        if oldTime == 0 {
            oldTime = curentTime
        }
        
        if pause {
            oldTime = curentTime
        } else {
            time += curentTime - oldTime
            oldTime = curentTime
        }
    }
    
    func getCurentTime() -> String {
        
        let minute = Int(time / 60)
        let second = Int(time) % 60
        
        var returnTime = ""
        
        if minute < 10 {
            returnTime += "0\(minute):"
        } else {
            returnTime += "\(minute):"
        }

        if second < 10 {
            returnTime += "0\(second)"
        } else {
            returnTime += "\(second)"
        }
        
        return returnTime
    }
}
