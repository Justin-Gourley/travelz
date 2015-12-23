//
//  MainMenuVC.swift
//  TravelZ
//
//  Created by Justin on 12/14/15.
//  Copyright © 2015 Justin. All rights reserved.
//

import UIKit

class MainMenuVC: UIViewController {

    let info = AppDelegate()
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    @IBAction func goToGame()
    {
        performSegueWithIdentifier("gameSegue", sender: nil)
    }
    
    @IBAction func returnToGame(storyboard:UIStoryboardSegue)
    {
        
    }
    @IBAction func resetSavePressed(sender: AnyObject) {
        resetSave()
    }
    
    func resetSave()
    {
        print("Save reset...")
        NSUserDefaults.standardUserDefaults() .setObject(0, forKey: "level")
        NSUserDefaults.standardUserDefaults() .setObject(100, forKey: "barricadeHealth")
        NSUserDefaults.standardUserDefaults() .synchronize()
    }
}
