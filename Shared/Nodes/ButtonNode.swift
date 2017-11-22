//
//  ButtonNode.swift
//  ColorWars
//
//  Created by Kirill Botalov on 04.07.16.
//  Copyright © 2016 Kirill Botalov. All rights reserved.
//

import SpriteKit

/// A type that can respond to `ButtonNode` button press events.
@objc protocol ButtonNodeResponderType: class {
    /// Responds to a button press.
    func buttonTriggered(_ button: ButtonNode)
}

enum ButtonIdentifier: String {
    case ColorSelector
    case MaskSelector
    case Pause
    case Replay
    case NextLevel
    case BrowseNextLevel
    case BrowsePreviousLevel
    case Play
    case Stop
    case Close
    case Settings
    case Daltonism
    case Tutorial
    case Baner

    /// Convenience array of all available button identifiers.
    static let allButtonIdentifiers: [ButtonIdentifier] = [
        .Pause, .Replay, .NextLevel, .BrowseNextLevel, .BrowsePreviousLevel, .Play, .Stop, .Close, .Settings, .Daltonism, .Tutorial, .Baner
    ]
}

class ButtonNode: SKSpriteNode {
    
    var buttonIdentifier: ButtonIdentifier!
    
    var colorButton: Color? {
        didSet {
            if colorButton != nil {
                self.color = Color.SKColorValue[colorButton!]! }
        }
    }

    var text: SKLabelNode?
    
    var maskNumber: Int?

    var isActive = true {
        didSet {
            if buttonIdentifier != .Daltonism && buttonIdentifier != .MaskSelector {
                self.isUserInteractionEnabled = isActive
            }

            if isActive {
                self.xScale = 1
                self.yScale = 1
            } else {
                self.xScale = 0.98
                self.yScale = 0.84
            }
        }
    }
    
    var responder: ButtonNodeResponderType {
        guard let responder = scene as? ButtonNodeResponderType else {
            fatalError("ButtonNode may only be used within a `ButtonNodeResponderType` scene.") }
        return responder
    }
    
    func addText() {
        
        text = SKLabelNode(fontNamed: "Andale Mono")
        text?.fontColor = SKColor.black
        text?.fontSize = 50
        text?.zPosition = 1
        text?.position = CGPoint(x: 0 , y: 0 - text!.fontSize / 2.5)
        self.addChild(text!)
    }

    func buttonTriggered() {
        
        // Forward the button press event through to the responder.
        if isUserInteractionEnabled {
            responder.buttonTriggered(self) }
    }
    
    #if os(OSX)
    /// NSResponder mouse handling.
    override func mouseDown(with event: NSEvent) {
    
        super.mouseDown(with: event)
        buttonTriggered()
    }
    
    #elseif os(iOS)
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesEnded(touches, with: event)
        buttonTriggered()
    }
    
    #endif
    
    /// Overridden to support `copyWithZone(_:)`.
    override init(texture: SKTexture?, color: SKColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    override func copy(with zone: NSZone?) -> Any {
        let newButton = super.copy(with: zone) as! ButtonNode
        
        // Copy the `ButtonNode` specific properties.
        newButton.buttonIdentifier = buttonIdentifier
        newButton.maskNumber = maskNumber
        
        return newButton
    }
    
    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        
        // Ensure that the node has a supported button identifier as its name.
        guard let nodeName = name, let buttonIdentifier = ButtonIdentifier(rawValue: nodeName) else {
            fatalError("Unsupported button name found.")
        }

        self.buttonIdentifier = buttonIdentifier

        self.isUserInteractionEnabled = true
    }
}
