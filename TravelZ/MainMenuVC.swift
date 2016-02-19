//
//  MainMenuVC.swift
//  TravelZ
//
//  Created by Justin on 12/14/15.
//  Copyright © 2015 Justin. All rights reserved.
//

import UIKit

class MainMenuVC: UIViewController {
    
    @IBOutlet weak var nextLevelButton: UIButton!
    var level: Int?
    var levelStage: Int = 0
    var stageButtons: [UIButton] = []
    var selectedStage: Int = -1
    var stageNum: [[Int]] = [[1,1,2,2,3,3,3,4,4,5], [2,2,3,3,4,4,4,5,5,6], [3,3,3,3,4,5,5,6,6,7], [4,4,4,5,5,6,6,7,7,8], [2,2,3,3,4,4,4,5,5,6], [2,2,3,3,4,4,4,5,5,6], [2,2,3,3,4,4,4,5,5,6], [2,2,3,3,4,4,4,5,5,6]]
    var gainSelect: Bool = false
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func viewDidAppear(animated: Bool) {
        loadData()
        setUpView()
        loadInfo()

        guard let finished: Bool = NSUserDefaults.standardUserDefaults() .objectForKey("finishedLevel") as? Bool
        else
        {
            print("Unable to load object 'finishedLevel'")
            NSUserDefaults.standardUserDefaults().setObject(false, forKey: "finishedLevel")
            NSUserDefaults.standardUserDefaults().synchronize()
            return
        }
        if (finished)
        {
            finishedLevel()
        }
        let numLeft = numOfStagesLeft()
        if (numLeft == 0)
        {
            nextLevelButton.hidden = false
        }
        else
        {
            nextLevelButton.hidden = false
        }
    }
    
    func finishedLevel()
    {
        print("Finished Stage: \(selectedStage)!")
        NSUserDefaults.standardUserDefaults().setObject(false, forKey: "finishedLevel")
        NSUserDefaults.standardUserDefaults().synchronize()
        stageButtons[selectedStage].enabled = false
        stageButtons[selectedStage].setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        selectedStage = -1
        saveInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gainSelect = false
    }
    
    @IBAction func goToNextLevel(sender: AnyObject) {
        for (var i = 0; i < stageButtons.count; i++)
        {
            stageButtons[i].enabled = true
        }
        saveInfo()
        performSegueWithIdentifier("nextLevelSegue", sender: self)
    }
    
    func saveInfo()
    {
        var stageInfo: [Bool] = []
        for (var i = 0; i < stageButtons.count; i++)
        {
            stageInfo.append(stageButtons[i].enabled)
        }
        NSUserDefaults.standardUserDefaults() .setObject(stageInfo, forKey: "stageInfo")
        NSUserDefaults.standardUserDefaults() .synchronize()
    }
    func loadInfo()
    {
        guard let info: [Bool] = (NSUserDefaults.standardUserDefaults() .objectForKey("stageInfo") as? [Bool])
        else
        {
            print("Unable to get stageInfo!")
            return
        }
        print("Loading Stage Data:")
        var count = 0
        if (info.count > stageButtons.count)
        {count = stageButtons.count}
        else
        {count = info.count}
        for (var i = 0; i < count; i++)
        {
            stageButtons[i].enabled = info[i]
            if (stageButtons[i].enabled == false)
            {
                stageButtons[i].setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
            }
            else
            {
                stageButtons[i].setTitleColor(UIColor.blackColor(), forState: .Normal)
            }
        }
    }
    
    @IBAction func goToGame()
    {
        if (selectedStage > -1)
        {
            if (gainSelect == false)
            {
                NSUserDefaults.standardUserDefaults() .setObject(stageNum[level!][selectedStage], forKey: "levelStage")
                performSegueWithIdentifier("gainSegue", sender: nil)
            }
        }
        else
        {
            print("Select a stage first")
        }
    }
    
    func numOfStagesLeft() -> Int
    {
        var numLeft: Int = 0
        numLeft = stageButtons.count
        print("numLeft: \(numLeft), stages: \(stageButtons.count)")
        for (var i = 0; i < stageButtons.count; i++)
        {
            if (stageButtons[i].enabled == false)
            {
                numLeft--
            }
        }
        print("Stages remaining: \(numLeft)")
        return numLeft
    }
    
    @IBAction func returnToGame(storyboard:UIStoryboardSegue)
    {
        let numLeft = numOfStagesLeft()
        if (numLeft == 0)
        {
            nextLevelButton.hidden = false
        }
        else
        {
            nextLevelButton.hidden = true
        } 
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
        CGPoint(x: width * 7, y: height * 7)],
        //level 2
        [CGPoint(x: width * 2, y: height),
        CGPoint(x: width * 1, y: height * 2),
        CGPoint(x: width * 6, y: height * 2),
        CGPoint(x: width * 3, y: height * 3),
        CGPoint(x: width * 5, y: height * 4),
        CGPoint(x: width, y: height * 5),
        CGPoint(x: width * 8, y: height * 5),
        CGPoint(x: width * 4, y: height * 7),
        CGPoint(x: width * 5, y: height * 7),
        CGPoint(x: width * 7, y: height * 7)],
        //level 3
        [CGPoint(x: width * 3, y: height),
        CGPoint(x: width * 1, y: height * 2),
        CGPoint(x: width * 6, y: height * 2),
        CGPoint(x: width * 3, y: height * 3),
        CGPoint(x: width * 5, y: height * 4),
        CGPoint(x: width, y: height * 5),
        CGPoint(x: width * 8, y: height * 5),
        CGPoint(x: width * 4, y: height * 7),
        CGPoint(x: width * 5, y: height * 7),
        CGPoint(x: width * 7, y: height * 7)],
        //level 4
        [CGPoint(x: width * 4, y: height),
        CGPoint(x: width * 1, y: height * 2),
        CGPoint(x: width * 6, y: height * 2),
        CGPoint(x: width * 3, y: height * 3),
        CGPoint(x: width * 5, y: height * 4),
        CGPoint(x: width, y: height * 5),
        CGPoint(x: width * 8, y: height * 5),
        CGPoint(x: width * 4, y: height * 7),
        CGPoint(x: width * 5, y: height * 7),
        CGPoint(x: width * 7, y: height * 7)],
        //level 5
        [CGPoint(x: width * 5, y: height),
        CGPoint(x: width * 1, y: height * 2),
        CGPoint(x: width * 6, y: height * 2),
        CGPoint(x: width * 3, y: height * 3),
        CGPoint(x: width * 5, y: height * 4),
        CGPoint(x: width, y: height * 5),
        CGPoint(x: width * 8, y: height * 5),
        CGPoint(x: width * 4, y: height * 7),
        CGPoint(x: width * 5, y: height * 7),
        CGPoint(x: width * 7, y: height * 7)],
        //level 6
        [CGPoint(x: width * 6, y: height),
        CGPoint(x: width * 1, y: height * 2),
        CGPoint(x: width * 6, y: height * 2),
        CGPoint(x: width * 3, y: height * 3),
        CGPoint(x: width * 5, y: height * 4),
        CGPoint(x: width, y: height * 5),
        CGPoint(x: width * 8, y: height * 5),
        CGPoint(x: width * 4, y: height * 7),
        CGPoint(x: width * 5, y: height * 7),
        CGPoint(x: width * 7, y: height * 7)],
        //level 7
        [CGPoint(x: width * 7, y: height),
        CGPoint(x: width * 1, y: height * 2),
        CGPoint(x: width * 6, y: height * 2),
        CGPoint(x: width * 3, y: height * 3),
        CGPoint(x: width * 5, y: height * 4),
        CGPoint(x: width, y: height * 5),
        CGPoint(x: width * 8, y: height * 5),
        CGPoint(x: width * 4, y: height * 7),
        CGPoint(x: width * 5, y: height * 7),
        CGPoint(x: width * 7, y: height * 7)],
        //level 8
        [CGPoint(x: width * 8, y: height),
        CGPoint(x: width * 1, y: height * 2),
        CGPoint(x: width * 6, y: height * 2),
        CGPoint(x: width * 3, y: height * 3),
        CGPoint(x: width * 5, y: height * 4),
        CGPoint(x: width, y: height * 5),
        CGPoint(x: width * 8, y: height * 5),
        CGPoint(x: width * 4, y: height * 7),
        CGPoint(x: width * 5, y: height * 7),
        CGPoint(x: width * 7, y: height * 7)]
        ]
        for (var i = 0; i < stageButtons.count; i++)
        {
            stageButtons[i].removeFromSuperview()
        }
        stageButtons.removeAll()
        stageButtons = []
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
        let stage: [Bool] = []
        let pointsArray: [Int] = [0, 0, 0, 0, 0]
        NSUserDefaults.standardUserDefaults() .setObject(false, forKey: "finishedLevel")
        NSUserDefaults.standardUserDefaults() .setObject(stage, forKey: "stageInfo")
        NSUserDefaults.standardUserDefaults() .setObject(pointsArray, forKey: "pointsArray")
        NSUserDefaults.standardUserDefaults() .setObject(0, forKey: "level")
        NSUserDefaults.standardUserDefaults() .setObject(1, forKey: "levelStage")
        NSUserDefaults.standardUserDefaults() .setObject(100, forKey: "barricadeHealth")
        NSUserDefaults.standardUserDefaults() .setObject(0, forKey: "crewCount")
        NSUserDefaults.standardUserDefaults() .synchronize()
        print("Game Save reset")
        
        let gunName: [String] = ["Colt45", "AK-47", "M9", "M4A1", "SCAR"]
        let gunType: [String] = ["Pistol", "Assault Rifle", "Pistol", "Assault Rifle", "Assault Rifle"]
        let gunDescription: [String] = ["Pistol", "Assault Rifle", "desc here...", "desc here...", "desc here..."]
        let gunAmmoCount: [Int] = [99999, 99999]
        let gunDamage: [Double] = [20, 30, 30, 25, 15]
        let gunVelocity: [Double] = [100, 120, 120, 125, 100]
        let gunSpread: [Int] = [2, 5, 3, 3, 6]
        let gunShotSpeed: [Double] = [0.25, 0.1, 0.3, 0.105, 0.075]
        let gunAmmo: [Int] = [10, 30, 12, 30, 60]
        let gunReload: [Double] = [2, 3.5, 2.5, 3, 4]
        let gunUnlocked: [Bool] = [true, false, false, false, false]
        
        NSUserDefaults.standardUserDefaults() .setObject(gunName, forKey: "gunName")
        NSUserDefaults.standardUserDefaults() .setObject(gunAmmoCount, forKey: "gunAmmoCount")
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
        setUpView()
        loadInfo()
    }
}
