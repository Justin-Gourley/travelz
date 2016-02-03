//
//  GainScreen.swift
//  TravelZ
//
//  Created by Justin on 1/24/16.
//  Copyright © 2016 Justin. All rights reserved.
//

import UIKit

class GainScreen: UIViewController {

    var crewCount = 0
    var weaponPoints = 0
    var supplyPoints = 0
    var crewPoints = 0
    var repairPoints = 0
    var totalPoints = 0
    @IBOutlet weak var totalPointsLabel: UILabel!
    @IBOutlet weak var weaponLabel: UILabel!
    @IBOutlet weak var crewLabel: UILabel!
    @IBOutlet weak var repairLabel: UILabel!
    @IBOutlet weak var supplyLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCrewCount()
        totalPoints = (crewCount + 1) * 10
        totalPointsLabel.text = "Points: \(totalPoints)"
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    func getCrewCount()
    {
        guard let crewCountGet: Int = NSUserDefaults.standardUserDefaults() .valueForKey("crewCount") as? Int
            else {
                print("Unable to get crew count")
                crewCount = 0
                return
        }
        crewCount = crewCountGet
        print("Crew count: \(crewCount)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func weaponAdd(sender: AnyObject)
    {
        if (totalPoints > 0)
        {
            weaponPoints++
            totalPoints--
            updateLabel("weaponsLabel")
        }
        else
        {
            print("not enough total points")
        }
    }
    @IBAction func weaponSub(sender: AnyObject)
    {
        if (weaponPoints > 0)
        {
            weaponPoints--
            totalPoints++
            updateLabel("weaponsLabel")
        }
        else
        {
            print("not enough weapon points")
        }
    }
    @IBAction func supplyAdd(sender: AnyObject)
    {
        if (totalPoints > 0)
        {
            supplyPoints++
            totalPoints--
            updateLabel("supplyLabel")
        }
        else
        {
            print("not enough total points")
        }
    }
    @IBAction func supplySub(sender: AnyObject)
    {
        if (supplyPoints > 0)
        {
            supplyPoints--
            totalPoints++
            updateLabel("supplyLabel")
        }
        else
        {
            print("not enough supply points")
        }
    }
    @IBAction func crewAdd(sender: AnyObject)
    {
        if (totalPoints > 0)
        {
            crewPoints++
            totalPoints--
            updateLabel("crewLabel")
        }
        else
        {
            print("not enough total points")
        }
    }
    @IBAction func crewSub(sender: AnyObject)
    {
        if (crewPoints > 0)
        {
            crewPoints--
            totalPoints++
            updateLabel("crewLabel")
        }
        else
        {
            print("not enough crew points")
        }
    }
    @IBAction func repairAdd(sender: AnyObject)
    {
        if (totalPoints > 0)
        {
            repairPoints++
            totalPoints--
            updateLabel("repairLabel")
        }
        else
        {
            print("not enough total points")
        }
    }
    @IBAction func repairSub(sender: AnyObject)
    {
        if (repairPoints > 0)
        {
            repairPoints--
            totalPoints++
            updateLabel("repairLabel")
        }
        else
        {
            print("not enough repair points")
        }
    }
    
    func updateLabel(label: String)
    {
        totalPointsLabel.text = ("Points: \(totalPoints)")
        if (label == "weaponsLabel")
        {weaponLabel.text="\(weaponPoints)"}
        else if (label == "supplyLabel")
        {supplyLabel.text="\(supplyPoints)"}
        else if (label == "crewLabel")
        {crewLabel.text="\(crewPoints)"}
        else if (label == "repairLabel")
        {repairLabel.text="\(repairPoints)"}
    }

    @IBAction func goToGame(sender: UIButton)
    {
        if (totalPoints == 0)
        {
            //put the code fot determining what happens here....
            weaponPoints *= 5
            supplyPoints *= 10
            crewPoints *= 3
            repairPoints *= 2
            if (repairPoints > 0)
            {
                var health: Int = (NSUserDefaults.standardUserDefaults() .valueForKey("barricadeHealth") as? Int)!
                health += repairPoints
                if (health > 100)
                {health = 100}
                NSUserDefaults.standardUserDefaults() .setObject(health, forKey: "barricadeHealth")
                NSUserDefaults.standardUserDefaults() .synchronize()
                print("Health \(health)")
            }
            let ran1: Int = (Int)(arc4random_uniform(100) + 1)
            if (ran1 <= weaponPoints)
            {
                let gunName = NSUserDefaults.standardUserDefaults() .valueForKey("gunName") as? [String]
                var gunUnlocked = NSUserDefaults.standardUserDefaults() .valueForKey("gunUnlocked") as? [Bool]
                let ranGun = (Int)(arc4random_uniform((UInt32)(gunName!.count)))
                print("Gun Unlocked: \(gunName![ranGun])")
                gunUnlocked![ranGun] = true
                NSUserDefaults.standardUserDefaults().setObject(gunUnlocked, forKey: "gunUnlocked")
                NSUserDefaults.standardUserDefaults().synchronize()
            }
            let ran2: Int = (Int)(arc4random_uniform(100) + 1)
            if (ran2 <= supplyPoints)
            {
                print("Got Supplies")
                //unlocked supplies!
            }
            let ran3: Int = (Int)(arc4random_uniform(100) + 1)
            if (ran3 <= crewPoints)
            {
                print("Got new crew member")
                crewCount++
                print("Crew count: \(crewCount)")
                NSUserDefaults.standardUserDefaults().setObject(crewCount, forKey: "crewCount")
                NSUserDefaults.standardUserDefaults().synchronize()
                //unlocked a new member for the crew!
            }
            //---
            performSegueWithIdentifier("gameSegue", sender: nil)
        }
        else
        {
            print("Spend all your points first....")
        }
    }
    
}
