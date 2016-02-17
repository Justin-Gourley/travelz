//
//  GunScreen.swift
//  TravelZ
//
//  Created by Justin on 1/4/16.
//  Copyright © 2016 Justin. All rights reserved.
//

import UIKit

class GunScreen: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    var descoveredGuns: [guns] = []
    let cellIdentifier = "gunCell"
    var curGun1: Int?
    var curGun2: Int?
    var gunSlotNums: [Int] = []
    
    struct guns
    {
        let name: String
        let type: String
        var damage: Double
        var velocity: Double
        var spread: Double
        var shotSpeed: Double
        var ammoClip: Int
        var reloadTime: Double
        var description: String
    }
    
    var gunIcons: [UIImage] = []
    var gunPictures: [String] = ["PlayerMoving1"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDescoveredGuns()
        
        //gunIcons = gunPictures.map {UIImage(named: $0)!}
        let gunCellNib = UINib(nibName: "GunCollectionViewCell", bundle: nil)
        collectionView.registerNib(gunCellNib, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //-----Loading-----
    func loadDescoveredGuns()
    {
        let gunName: [String] = loadString("gunName")
        let gunType: [String] = loadString("gunType")
        let gunDamage: [Double] = loadDouble("gunDamage")
        let gunVelocity: [Double] = loadDouble("gunVelocity")
        let gunSpread: [Double] = loadDouble("gunSpread")
        let gunShotSpeed: [Double] = loadDouble("gunShotSpeed")
        let gunAmmo: [Double] = loadDouble("gunAmmo")
        let gunReload: [Double] = loadDouble("gunReload")
        let gunDescription: [String] = loadString("gunDescription")
        let gunUnlocked: [Bool] = (NSUserDefaults.standardUserDefaults() .objectForKey("gunUnlocked") as? [Bool])!
        
        curGun1 = loadGunSlot("gunSlot1")
        curGun2 = loadGunSlot("gunSlot2")
        
        for (var i = 0; i < gunName.count; i++)
        {
            if (gunUnlocked[i])
            {
            descoveredGuns.append(guns.init(name: gunName[i], type: gunType[i], damage: gunDamage[i], velocity: gunVelocity[i], spread: gunSpread[i], shotSpeed: gunShotSpeed[i], ammoClip: (Int)(gunAmmo[i]), reloadTime: gunReload[i], description: gunDescription[i]))
            gunSlotNums.append(i)
            if (curGun1 == i)
            {curGun1 = (gunSlotNums.count - 1)}
            if (curGun2 == i)
            {curGun2 = (gunSlotNums.count - 1)}
            }
        }
        
       
        
        print("Completed Load...")
    }
    func loadGunSlot(object: String) -> Int
    {
        guard let gun = NSUserDefaults.standardUserDefaults() .objectForKey("\(object)") as? Int
        else
        {
            print("unable to load \(object)")
            return -1
        }
        return gun
    }
    //loading funcs
    func loadString(object: String) -> [String]
    {
        guard let stringArray: [String] = NSUserDefaults.standardUserDefaults() .objectForKey("\(object)") as? [String]
            else {
                print("Unable to load \(object)")
                return []
        }
        return stringArray
    }
    func loadDouble(object: String) -> [Double]
    {
        guard let doubleArray: [Double] = NSUserDefaults.standardUserDefaults() .objectForKey("\(object)") as? [Double]
            else {
                print("Unable to load \(object)")
                return []
        }
        return doubleArray
    }
    //----/Loading-----
    
    @IBAction func returnToMainMenu(sender: AnyObject) {
        performSegueWithIdentifier("goToMainMenu", sender: nil)
    }
    
    func saveCurrentGuns(gunSlot: String, gunNumber: Int)
    {
        NSUserDefaults.standardUserDefaults() .setObject(gunNumber, forKey: "\(gunSlot)")
        NSUserDefaults.standardUserDefaults() .synchronize()
        print("Saved Gun Slot")
    }
    
}

extension GunScreen : UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return descoveredGuns.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        guard let gunCell = cell as? GunCollectionViewCell else {
            print("Got Wrong Cell!?!?!")
            return cell
        }
        var image: UIImage = UIImage(named: "PlayerStill-Colt45")!
        if (descoveredGuns[indexPath.item].name == "Pistol2")
        {
            image = UIImage(named: "gun-M9")!
        }
        else if (descoveredGuns[indexPath.item].name == "AssaultRifle2")
        {
            image = UIImage(named: "gun-M4A1")!
        }
        else if (descoveredGuns[indexPath.item].name == "Sniper1")
        {
            image = UIImage(named: "gun-AWP")!
        }
        else
        {
            image = UIImage(named: "gun-\(descoveredGuns[indexPath.item].name)")!
        }
        
        var gunEquiped: Bool = false
        if (indexPath.item == curGun1 || indexPath.item == curGun2)
        {
            gunEquiped = true
        }
        else
        {
            gunEquiped = false
        }
        gunCell.setViewCell(image, name: descoveredGuns[indexPath.item].name, description: descoveredGuns[indexPath.item].description, equiped: gunEquiped)
        
        return gunCell
    }
    
}

extension GunScreen : UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
            if (indexPath.item == curGun1 || indexPath.item == curGun2)
            {
                if (indexPath.item == curGun1)
                {
                    curGun1 = -1
                    saveCurrentGuns("gunSlot1", gunNumber: curGun1!)
                }
                else
                {
                    curGun2 = -1
                    saveCurrentGuns("gunSlot2", gunNumber: curGun2!)
                }
                collectionView.reloadData()
            }
            else
            {
                if (curGun1 == -1)
                {
                    curGun1 = indexPath.item
                    saveCurrentGuns("gunSlot1", gunNumber: gunSlotNums[indexPath.item])
                    collectionView.reloadData()
                }
                else if (curGun2 == -1)
                {
                    curGun2 = indexPath.item
                    saveCurrentGuns("gunSlot2", gunNumber: gunSlotNums[indexPath.item])
                    collectionView.reloadData()
                }
                else
                {
                    print("Un-equip a gun before equiping a different gun")
                }
            }
    }
}
