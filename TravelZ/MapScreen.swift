//
//  MapScreen.swift
//  TravelZ
//
//  Created by Justin on 2/11/16.
//  Copyright © 2016 Justin. All rights reserved.
//

import UIKit

class MapScreen: UIViewController {

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextLevel(sender: AnyObject) {
        var level: Int = (NSUserDefaults.standardUserDefaults() .objectForKey("level") as? Int)!
        level++
        print("Going to next level... (\(level))")
        NSUserDefaults.standardUserDefaults() .setObject(level, forKey: "level")
        NSUserDefaults.standardUserDefaults() .synchronize()
        navigationController?.popToRootViewControllerAnimated(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
