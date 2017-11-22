//
//  Level.swift
//  ColorWars
//
//  Created by Kirill Botalov on 25.07.16.
//  Copyright © 2016 Kirill Botalov. All rights reserved.
//

import SpriteKit
import CoreData

class Level: NSManagedObject {
    
    @NSManaged var index: Int32
    
    @NSManaged var name: String
    @NSManaged var locked: Bool
    //для расчета очков
    @NSManaged var turn: Int32
    //start position
    @NSManaged var player: Int32
    @NSManaged var ai: Int32
    //бонусный ход ai
    @NSManaged var bonus: Int32

    var map: [Int]?
    // texturePreview create in LevelManager
    var texturePreview: SKTexture?

    convenience init?(key : [String : AnyObject], index: Int, context: NSManagedObjectContext) {

        guard let entity = NSEntityDescription.entity(forEntityName: "Level", in: context) else {return nil}
        
        self.init(entity: entity, insertInto: context)

        self.index = Int32(index)
        self.name = key["name"] as! String
        self.player = key["player"] as! Int32
        self.ai = key["ai"] as! Int32
        self.locked = true
        self.turn = 99999
        self.bonus = key["bonus"] as! Int32
    }
    
    func tutorial(player: Int32, ai: Int32, bonus: Int32) {
        
        self.player = player
        self.ai = ai
        self.bonus = bonus
    }
    
    func createMap() {

        let url = Bundle.main.url(forResource: self.name, withExtension: "level")

        if url != nil {
            self.map = NSArray(contentsOf: url!) as? [Int]
        } else {
            fatalError("nil level")
        }
    }
    
    func getIndex() -> Int { return Int(index) }
    func getPlayer() -> Int { return Int(player) }
    func getAI() -> Int { return Int(ai) }
    func getTurn() -> Int { return Int(turn) }
    func getBonus() -> Int { return Int(bonus) }
    
    func putIndex(index: Int) { self.index = Int32(index) }
    func putPlayer(Player: Int) { self.player = Int32(player) }
    func putAI(AI: Int) { self.ai = Int32(ai) }
    func putTurn(turn: Int) { self.turn = Int32(turn) }
    func putBonus(bonus: Int) { self.bonus = Int32(bonus) }
}
