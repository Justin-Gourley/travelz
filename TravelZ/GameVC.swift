//
//  GameVC.swift
//  TravelZ
//
//  Created by Justin on 12/14/15.
//  Copyright © 2015 Justin. All rights reserved.
//

import UIKit
import SceneKit
import SpriteKit

class GameVC: UIViewController {

    @IBOutlet weak var gameScreen: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameScreen.hidden = true
        gameScreen.allowsTransparency = true
        gameScreen.backgroundColor = UIColor.clearColor()
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let scene = GameScreen()
        scene.scaleMode = .ResizeFill
        scene.viewController = self
        gameScreen.presentScene(scene)
        gameScreen.hidden = false
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
