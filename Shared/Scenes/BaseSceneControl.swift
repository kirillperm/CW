//
//  BaseSceneControl.swift
//  ColorWars
//
//  Created by Kirill Botalov on 04.07.16.
//  Copyright © 2016 Kirill Botalov. All rights reserved.
//

import SpriteKit

extension BaseScene: ButtonNodeResponderType {
    
    /// Searches the scene for all `ButtonNode`s.
    func findAllButtonsInScene() -> [ButtonNode] {
        return ButtonIdentifier.allButtonIdentifiers.flatMap { buttonIdentifier in
            childNode(withName: "//\(buttonIdentifier.rawValue)") as? ButtonNode
        }
    }
    
    func findButtonsColorSelector() -> [ButtonNode] {
        
        var returnedArray: [ButtonNode] = []
        
        for i in 0..<5 {
            let colorSelectorNode = childNode(withName: "//ColorSelector") as? ButtonNode
            
            if colorSelectorNode != nil {
                colorSelectorNode?.name = "ColorSelector \(i)"
                
                if self.daltonism {
                    colorSelectorNode?.addText() }
                
                returnedArray.append(colorSelectorNode!)
            }
            
        }
        
        return returnedArray
    }

    func buttonTriggered(_ button: ButtonNode) {
        /*
        let scaleAnimation = SKAction.scale(to: 1, duration: TimeInterval(0.1))
        button.setScale(0.90)
        button.run(scaleAnimation, completion: {
            switch button.buttonIdentifier! {
            default:
                fatalError("Unsupported ButtonNode type in Scene.")
            }
        })
        */
        switch button.buttonIdentifier! {
        case .Baner:
            #if os(OSX)
                break
            #else
                let url = URL(string: "https://itunes.apple.com/app/id1271729672")!
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            #endif
        default:
            fatalError("Unsupported ButtonNode type in Scene.")
        }
    }
}
