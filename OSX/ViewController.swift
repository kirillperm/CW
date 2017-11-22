//
//  ViewController.swift
//  OSX
//
//  Created by Kirill Botalov on 30.06.17.
//
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {

    @IBOutlet var skView: SKView!
    
    var sceneManager: SceneManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sceneManager = SceneManager(skView: skView)
        sceneManager.scenePresentation(.menu)
    }
}

