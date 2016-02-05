//
//  MainMenuVC.swift
//  TravelZ
//
//  Created by Justin on 12/14/15.
//  Copyright © 2015 Justin. All rights reserved.
//

import UIKit

class MainMenuVC: UIViewController {
    
    var level: Int?
    var levelStage: Int = 0
    var stageButtons: [UIButton] = []
    var selectedStage: Int = -1
    var stageNum: [[Int]] = [[1,1,2,2,3,3,3,4,4,5]]
    var gainSelect: Bool = false
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setUpView()
        gainSelect = false
    }
    
    @IBAction func goToGame()
    {
        if (selectedStage > -1)
        {
            if (gainSelect == false)
            {
                //gainSelect = true;
                NSUserDefaults.standardUserDefaults() .setObject(stageNum[level!][selectedStage], forKey: "levelStage")
                stageButtons[selectedStage].enabled = false
                stageButtons[selectedStage].setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
                selectedStage = -1
                performSegueWithIdentifier("gainSegue", sender: nil)
            }
//            else
//            {
//                NSUserDefaults.standardUserDefaults() .setObject(stageNum[level!][selectedStage], forKey: "levelStage")
//                stageButtons[selectedStage].enabled = false
//                stageButtons[selectedStage].setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
//                selectedStage = -1
//                performSegueWithIdentifier("gameSegue", sender: nil)
//                gainSelect = false
//            }
        }
        else
        {
            print("Select a stage first")
        }
    }
    
    @IBAction func returnToGame(storyboard:UIStoryboardSegue)
    {
        
    }
    @IBAction func resetSavePressed(sender: AnyObject) {
        resetSave()
    }
    @IBAction func goToGunScreen(sender: AnyObject) {
        performSegueWithIdentifier("gunSegue", sender: nil)
    }
    
    
    func setUpView()
    {
        let width = self.view.frame.width / 10
        let height = self.view.frame.height / 10
        var positions: [[CGPoint]] =
        [
        //level 1
        [CGPoint(x: width * 1, y: height),
        CGPoint(x: width * 1, y: height * 2),
        CGPoint(x: width * 6, y: height * 2),
        CGPoint(x: width * 3, y: height * 3),
        CGPoint(x: width * 5, y: height * 4),
        CGPoint(x: width, y: height * 5),
        CGPoint(x: width * 8, y: height * 5),
        CGPoint(x: width * 4, y: height * 7),
        CGPoint(x: width * 5, y: height * 7),
        CGPoint(x: width * 7, y: height * 5)]
        ]
        
        for (var i = 0; i < 10; i++)
        {
            let rect = CGRect(x: positions[level!][i].x, y: positions[level!][i].y, width: 100, height: 50)
            let button: UIButton = UIButton(frame: rect)
            button.addTarget(self, action: "stageSelected:", forControlEvents: .TouchUpInside)
            button.setTitle("\(i)", forState: .Normal)
            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
            stageButtons.append(button)
            self.view.addSubview(stageButtons[i])
        }
    }
    
    func stageSelected(sender: UIButton!)
    {
        if (selectedStage != -1)
        {
            stageButtons[selectedStage].setTitleColor(UIColor.blackColor(), forState: .Normal)
        }
        let stage: Int = (Int)((sender.titleLabel?.text)!)!
        stageButtons[stage].setTitleColor(UIColor.redColor(), forState: .Normal)
        selectedStage = stage
    }
    
    func loadData()
    {
       guard let levelLoad = NSUserDefaults.standardUserDefaults() .objectForKey("level") as? Int
        else
        {
            print("unable to load level... setting to 0")
            level = 0
            return
        }
        level = levelLoad
        print("Successfully loaded data")
    }
    
    @IBAction func giveAll()
    {
        let gunUnlocked: [Bool] = [true, true, true, true, true, true, true, true]
        NSUserDefaults.standardUserDefaults() .setObject(gunUnlocked, forKey: "gunUnlocked")
        NSUserDefaults.standardUserDefaults() .synchronize()
    }
    
    func resetSave()
    {
        print("Save reset...")
        NSUserDefaults.standardUserDefaults() .setObject(0, forKey: "level")
        NSUserDefaults.standardUserDefaults() .setObject(1, forKey: "levelStage")
        NSUserDefaults.standardUserDefaults() .setObject(100, forKey: "barricadeHealth")
        NSUserDefaults.standardUserDefaults() .synchronize()
        print("Game Save reset")
        
        let gunName: [String] = ["Colt45", "AK-47", "AWP", "M9", "Pistol2", "M4A1", "AssaultRifle2", "Sniper1"]
        let gunType: [String] = ["Pistol", "Assault Rifle", "Sniper Rifle", "Pistol", "Pistol", "Assault Rifle", "Assault Rifle", "Sniper Rifle"]
        let gunDescription: [String] = ["Pistol", "Assault Rifle", "Sniper Rifle", "desc here...", "desc here...", "desc here...", "desc here...", "desc here..."]
        let gunDamage: [Double] = [20, 30, 100, 30, 40, 25, 15, 125]
        let gunVelocity: [Double] = [100, 120, 150, 120, 130, 125, 100, 175]
        let gunSpread: [Int] = [2, 5, 1, 3, 4, 3, 6, 0]
        let gunShotSpeed: [Double] = [0.25, 0.1, 0.4, 0.3, 0.35, 0.105, 0.075, 0.3]
        let gunAmmo: [Int] = [10, 30, 10, 12, 7, 30, 60, 6]
        let gunReload: [Double] = [2, 3.5, 3, 2.5, 2.75, 3, 4, 2]
        let gunUnlocked: [Bool] = [true, false, false, false, false, false, false, false]
        
        NSUserDefaults.standardUserDefaults() .setObject(gunName, forKey: "gunName")
        NSUserDefaults.standardUserDefaults() .setObject(gunType, forKey: "gunType")
        NSUserDefaults.standardUserDefaults() .setObject(gunDescription, forKey: "gunDescription")
        NSUserDefaults.standardUserDefaults() .setObject(gunDamage, forKey: "gunDamage")
        NSUserDefaults.standardUserDefaults() .setObject(gunVelocity, forKey: "gunVelocity")
        NSUserDefaults.standardUserDefaults() .setObject(gunSpread, forKey: "gunSpread")
        NSUserDefaults.standardUserDefaults() .setObject(gunShotSpeed, forKey: "gunShotSpeed")
        NSUserDefaults.standardUserDefaults() .setObject(gunAmmo, forKey: "gunAmmo")
        NSUserDefaults.standardUserDefaults() .setObject(gunReload, forKey: "gunReload")
        NSUserDefaults.standardUserDefaults() .setObject(gunUnlocked, forKey: "gunUnlocked")
        NSUserDefaults.standardUserDefaults() .setObject(0, forKey: "gunSlot1")
        NSUserDefaults.standardUserDefaults() .setObject(-1, forKey: "gunSlot2")
        NSUserDefaults.standardUserDefaults() .synchronize()
        print("Game Guns reset")
        
    }
}
