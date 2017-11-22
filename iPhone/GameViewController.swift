//
//  GameViewController.swift
//  iPhone
//
//  Created by Kirill Botalov on 30.06.17.
//
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var sceneManager: SceneManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.yourVC = self
        
        let skView = self.view as! SKView

        sceneManager = SceneManager(skView: skView)
        sceneManager.scenePresentation(.menu)
    }
    
    func enterBackgrounde() {
        sceneManager.scene.enterBackgrounde()
    }
    
    func returnBackgrounde() {
        sceneManager.scene.returnBackgrounde()
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
