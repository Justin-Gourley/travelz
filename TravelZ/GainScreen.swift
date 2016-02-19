//
//  GainScreen.swift
//  TravelZ
//
//  Created by Justin on 1/24/16.
//  Copyright © 2016 Justin. All rights reserved.
//

import UIKit

class GainScreen: UIViewController {

    var weaponPoints = 0
    var supplyPoints = 0
    var crewPoints = 0
    var repairPoints = 0
    var totalPoints = 0
    var currentCrew = 0
    @IBOutlet weak var totalPointsLabel: UILabel!
    @IBOutlet weak var weaponLabel: UILabel!
    @IBOutlet weak var crewLabel: UILabel!
    @IBOutlet weak var repairLabel: UILabel!
    @IBOutlet weak var supplyLabel: UILabel!
    //weaponslider
    @IBOutlet weak var weaponSlider: UISlider!
    @IBOutlet weak var supplySlider: UISlider!
    @IBOutlet weak var crewSlider: UISlider!
    @IBOutlet weak var repairSlider: UISlider!
    let infoCenter = AppDelegate()
    
    @IBOutlet weak var continueButton2: UIButton!
    @IBOutlet weak var unlockImage: UIImageView!
    @IBOutlet weak var unlockTitle: UILabel!
    @IBOutlet weak var unlockDescription: UILabel!
    @IBOutlet weak var unlockPicture: UIImageView!
    @IBOutlet weak var visualEffect: UIVisualEffectView!
    var newCrew = false
    var gunUnlock = ""
    var ammoUnlock = ""
    var ammoGet = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueButton2.hidden = true
        unlockImage.hidden = true
        unlockTitle.hidden = true
        unlockDescription.hidden = true
        unlockPicture.hidden = true
        visualEffect.hidden = true
        let crewCount = getCrewCount()
        totalPoints = (crewCount + 1) * 10
        weaponSlider.maximumValue = (Float)(totalPoints)
        weaponSlider.value = 0
        crewSlider.maximumValue = (Float)(totalPoints)
        crewSlider.value = 0
        supplySlider.maximumValue = (Float)(totalPoints)
        supplySlider.value = 0
        repairSlider.maximumValue = (Float)(totalPoints)
        repairSlider.value = 0
        let pointsArray = getSliderPoints()
        if (pointsArray.count > 1)
        {
            print("Loaded previous slider data")
            weaponSlider.value = (Float)(pointsArray[0])
            supplySlider.value = (Float)(pointsArray[1])
            crewSlider.value = (Float)(pointsArray[2])
            repairSlider.value = (Float)(pointsArray[3])
            let total = pointsArray[0] + pointsArray[1] + pointsArray[2] + pointsArray[3]
            totalPoints -= total
        }
        totalPointsLabel.text = "Points: \(totalPoints)"
    }
    
    func setSliderPoints(pointsArray: [Int])
    {
        NSUserDefaults.standardUserDefaults() .setObject(pointsArray, forKey: "pointsArray")
        print("Set slider data: \(pointsArray)")
    }
    
    func getSliderPoints() -> [Int]
    {
        var pointsArray = [0]
        guard let points = NSUserDefaults.standardUserDefaults() .valueForKey("pointsArray") as? [Int]
        else{
            print("No Slider data to load")
            pointsArray = [0]
            return pointsArray
        }
        pointsArray = points
        print(points)
        if (pointsArray[0] == 0 && pointsArray[1] == 0 && pointsArray[2] == 0 && pointsArray[3] == 0)
        {
            pointsArray = [0]
        }
        else
        {
            weaponPoints = pointsArray[0]
            updateLabel("weaponsLabel")
            supplyPoints = pointsArray[1]
            updateLabel("supplyLabel")
            crewPoints = pointsArray[2]
            updateLabel("crewLabel")
            repairPoints = pointsArray[3]
            updateLabel("repairLabel")
        }
        print("returning slider data: \(pointsArray)   w:\(weaponPoints) s:\(supplyPoints) c:\(crewPoints) r:\(repairPoints)")
        return pointsArray
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    func getCrewCount() -> Int
    {
        guard let crewCountGet: Int = NSUserDefaults.standardUserDefaults() .valueForKey("crewCount") as? Int
            else {
                print("Unable to get crew count")
                return 0
        }
        print("Crew count: \(crewCountGet)")
        return crewCountGet
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func weaponSliderUpdate(sender: AnyObject) {
        var parseInt: Int = (Int)(weaponSlider.value)
        if (parseInt > weaponPoints)
        {
            for (var i = (weaponPoints + 1); i <= parseInt;)
            {
                weaponPoints = i
                totalPoints--
                if (totalPoints < 0)
                {
                    weaponPoints -= 1
                    parseInt = weaponPoints
                    totalPoints = 0
                    i = parseInt
                }
                i++
            }
        }
        else if (weaponPoints > parseInt)
        {
            for (var i = (weaponPoints - 1); i >= parseInt;)
            {
                weaponPoints = i
                totalPoints++
                i--
            }
        }
        weaponSlider.value = (Float)(parseInt)
        updateLabel("weaponsLabel")
    }
    @IBAction func supplySliderUpdate(sender: AnyObject) {
        var parseInt: Int = (Int)(supplySlider.value)
        if (parseInt > supplyPoints)
        {
            for (var i = (supplyPoints + 1); i <= parseInt;)
            {
                supplyPoints = i
                totalPoints--
                if (totalPoints < 0)
                {
                    supplyPoints -= 1
                    parseInt = supplyPoints
                    totalPoints = 0
                    i = parseInt
                }
                i++
            }
        }
        else if (supplyPoints > parseInt)
        {
            for (var i = (supplyPoints - 1); i >= parseInt;)
            {
                supplyPoints = i
                totalPoints++
                i--
            }
        }
        supplySlider.value = (Float)(parseInt)
        updateLabel("supplyLabel")
    }
    @IBAction func crewSliderUpdate(sender: AnyObject) {
        var parseInt: Int = (Int)(crewSlider.value)
        if (parseInt > crewPoints)
        {
            for (var i = (crewPoints + 1); i <= parseInt;)
            {
                crewPoints = i
                totalPoints--
                if (totalPoints < 0)
                {
                    crewPoints -= 1
                    parseInt = crewPoints
                    totalPoints = 0
                    i = parseInt
                }
                i++
            }
        }
        else if (crewPoints > parseInt)
        {
            for (var i = (crewPoints - 1); i >= parseInt;)
            {
                crewPoints = i
                totalPoints++
                i--
            }
        }
        crewSlider.value = (Float)(parseInt)
        updateLabel("crewLabel")
    }
    @IBAction func repairSliderUpdate(sender: AnyObject) {
        var parseInt: Int = (Int)(repairSlider.value)
        if (parseInt > repairPoints)
        {
            for (var i = (repairPoints + 1); i <= parseInt;)
            {
                repairPoints = i
                totalPoints--
                if (totalPoints < 0)
                {
                    repairPoints -= 1
                    parseInt = repairPoints
                    totalPoints = 0
                    i = parseInt
                }
                i++
            }
        }
        else if (repairPoints > parseInt)
        {
            for (var i = (repairPoints - 1); i >= parseInt;)
            {
                repairPoints = i
                totalPoints++
                i--
            }
        }
        repairSlider.value = (Float)(parseInt)
        updateLabel("repairLabel")
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
    @IBAction func goBack(sender: AnyObject) {
        navigationController?.popToRootViewControllerAnimated(true)
    }

    @IBAction func goToGame(sender: UIButton)
    {
        var unlockedSomething = false
        gunUnlock = ""
        if (totalPoints == 0)
        {
            let pointsArray = [weaponPoints, supplyPoints, crewPoints, repairPoints, totalPoints]
            setSliderPoints(pointsArray)
            //put the code fot determining what happens here....
            weaponPoints *= 5
            supplyPoints *= 10
            crewPoints *= 5
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
                unlockedSomething = true
                gunUnlock = gunName![ranGun]
                NSUserDefaults.standardUserDefaults().setObject(gunUnlocked, forKey: "gunUnlocked")
                NSUserDefaults.standardUserDefaults().synchronize()
            }
            let ran2: Int = (Int)(arc4random_uniform(100) + 1)
            if (ran2 <= supplyPoints)
            {
                print("Got Supplies")
                var ammo: [Int] = NSUserDefaults.standardUserDefaults() .objectForKey("gunAmmoCount") as! [Int]
                let ran = (Int)((arc4random_uniform(10) + 1))
                if (ran <= 6)
                {
                    let ran = (Int)((arc4random_uniform(40) + 1))
                    ammoUnlock = "Pistol"
                    ammo[0] += ran
                    ammoGet = ran
                }
                else
                {
                    let ran = (Int)((arc4random_uniform(40) + 1))
                    ammoUnlock = "Assault Rifle"
                    ammo[1] += ran
                    ammoGet = ran
                }
                //unlocked supplies!
                unlockedSomething = true
                NSUserDefaults.standardUserDefaults() .setObject(ammo, forKey: "gunAmmoCount")
                NSUserDefaults.standardUserDefaults() .synchronize()
            }
            let ran3: Int = (Int)(arc4random_uniform(100) + 1)
            if (ran3 <= crewPoints)
            {
                print("Got new crew member")
                let count = getCrewCount()
                currentCrew = count
                currentCrew++
                print("Crew count: \(currentCrew)")
                NSUserDefaults.standardUserDefaults().setObject(currentCrew, forKey: "crewCount")
                NSUserDefaults.standardUserDefaults().synchronize()
                unlockedSomething = true
                newCrew = true
                //unlocked a new member for the crew!
            }
            //---
            if (!unlockedSomething)
            {
                performSegueWithIdentifier("gameSegue", sender: nil)
            }
            else
            {
                showUnlocked()
            }
        }
        else
        {
            print("Spend all your points first....")
        }
    }
    
    func showUnlocked()
    {
//        unlockImage.image = UIImage(named: "")
        unlockTitle.text = "New Unlock!"
        unlockDescription.text = ""
        var descriptionText = ""
        var gunText = ""
        var ammoText = ""
        var crewText = ""
        if (gunUnlock != "")
        {
            gunText = "New Weapon found!     You found a \(gunUnlock)!"
            unlockPicture.image = UIImage(named: "gun-\(gunUnlock)")
        }
        if (ammoUnlock != "")
        {
            if (gunUnlock == "")
            {
                unlockPicture.image = UIImage(named: "bullet_\(ammoUnlock)")   
            }
            ammoText = "Supplies found!     You found \(ammoGet) \(ammoUnlock) rounds!"
        }
        if (newCrew == true)
        {
            crewText = "New Crew member found!     Current Crew Count: \(currentCrew)"
        }
        descriptionText = "\(gunText)\n\(ammoText)\n\(crewText)"
        unlockDescription.text = descriptionText
        continueButton2.hidden = false
        unlockImage.hidden = false
        unlockTitle.hidden = false
        unlockDescription.hidden = false
        unlockPicture.hidden = false
        visualEffect.hidden = false
    }
    @IBAction func goToGame2(sender: AnyObject) {
        performSegueWithIdentifier("gameSegue", sender: nil)
    }
}
