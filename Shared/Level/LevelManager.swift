//
//  LevelManager.swift
//  ColorWars
//
//  Created by Kirill Botalov on 29.07.16.
//  Copyright © 2016 Kirill Botalov. All rights reserved.
//

import Foundation
import CoreData

final class LevelManager {

    var levels: [Level] = []
    var curentLevelNumber = 0
    
    let levelsListFile: String

    init() {
        
        #if FREE
            levelsListFile = "Levels-free"
        #else
            levelsListFile = "Levels"
        #endif
        
        loadLevelInCoreData()
        
        if levels.count == 0 {
            loadLevelInFile()
            levels[0].locked = false
            CoreDataStackManager.defaultStack.saveContext()
        } else if levels.count != checkNewLevel() {
            checkLevelFileAndCoreData()
            CoreDataStackManager.defaultStack.saveContext()
        }
        
        //загрузка карт меню
        //выбор последнего открытого уровня
        var lastOpenLevel = 0
        for level in levels {
            level.createMap()
            if !level.locked {
                curentLevelNumber = lastOpenLevel }
            lastOpenLevel += 1
        }
    }

    func loadLevelInCoreData() {

        let managedObjectContext = CoreDataStackManager.defaultStack.managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"Level")
        
        let sortDescriptor = NSSortDescriptor(key: "index", ascending: true)
        request.sortDescriptors = [sortDescriptor]

        do {
            levels = try managedObjectContext.fetch(request) as! [Level]
        }
        catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    func curentLevel() -> Level {
        return levels[curentLevelNumber]
    }
    
    func updateLevel(newTurn: Int) -> Bool {
        
        var newRecord = false

        if newTurn < curentLevel().getTurn() {
            curentLevel().putTurn(turn: newTurn)
            newRecord = true
        }
        if curentLevelNumber + 1 < levels.count {
            levels[curentLevelNumber + 1].locked = false
        }
        CoreDataStackManager.defaultStack.saveContext()
        
        return newRecord
    }
    
    func loadLevelInFile() {

        let managedObjectContext = CoreDataStackManager.defaultStack.managedObjectContext
        
        let url = Bundle.main.url(forResource: levelsListFile, withExtension: "plist")!
        let request = NSArray(contentsOf: url) as! [[String: AnyObject]]
        
        var index = 0
        for fetchLevel in request {
            levels.append(Level(key: fetchLevel, index: index, context: managedObjectContext)!)
            index += 1
        }
    }
    
    func checkLevelFileAndCoreData() {

        let managedObjectContext = CoreDataStackManager.defaultStack.managedObjectContext
        
        let url = Bundle.main.url(forResource: levelsListFile, withExtension: "plist")!
        let request = NSArray(contentsOf: url) as! [[String: AnyObject]]
        
        var lastLevel = 0
        var lastLevelisLocked = true

        var index = 0
        
        for fetchLevel in request {
            
            if index < levels.count {
                lastLevel = index
                lastLevelisLocked = levels[index].locked
                index += 1
                continue
            }
            levels.append(Level(key: fetchLevel, index: index, context: managedObjectContext)!)
            index += 1
        }
        
        if !lastLevelisLocked && (lastLevel + 1 < levels.count) {
            levels[lastLevel + 1].locked = false
        }
    }
    
    func checkNewLevel() -> Int {

        let url = Bundle.main.url(forResource: levelsListFile, withExtension: "plist")!
        let request = NSArray(contentsOf: url) as! [[String: AnyObject]]

        return request.count
    }

    func slideNextLevel() {
        
        curentLevelNumber += 1
        if curentLevelNumber == levels.count {
            curentLevelNumber = 0
        }
    }
    
    func slidePreviousLevel() {
    
        curentLevelNumber -= 1
        if curentLevelNumber < 0 {
            curentLevelNumber = levels.count - 1
        }
    }
}
