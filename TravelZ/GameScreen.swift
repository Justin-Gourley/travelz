//
//  GameScreen.swift
//  TravelZ
//
//  Created by Justin on 12/11/15.
//  Copyright © 2015 Justin. All rights reserved.
//

import UIKit
import SpriteKit

class GameScreen: SKScene {

    var effectStep: Bool = false
    var level: Int?
    var levelStage: Int?
    var bulletNode: [SKNode] = []
    var bulletFireTo: [CGPoint] = []
    var numberOfBullets = 0
    var playerNode: SKSpriteNode!
    var playerMove: Int = 0
    var isPlayerMoving = false
    var bulletIsActive: [Bool] = []
    var playerAnimateState = 0
    var bloodSplatter: [SKSpriteNode] = []
    var allowedToFire = true
    var shotsAt: CGPoint?
    var movingPlayer = false
    var numberOfZombies: Int = 0
    var zombieHealth: [Double] = []
    var zombieNodes: [SKSpriteNode] = []
    var zombieAnimationTick: [Int] = []
    var isZombieAnimating: [Bool] = []
    var isZombieAttacking: [Bool] = []
    var zombieClass: [zombieType] = []
    var isReloading = false
    var isFiring = false
    var isFiringPic = false
    var shotsRemaining = 0
    var moveTick = 0
    var zombiesLeft = 0
    var viewController: UIViewController?
    var hasGameEnded = false
    var barricadeNode: SKSpriteNode!
    var barricadeHealth: Double?
    var barricadeHealthNode: SKSpriteNode!
    var setAttackBack: [Int] = []
    var backgroundNode: SKSpriteNode?
    var backgroundEffectNode: [SKSpriteNode] = []
    var ammoNode: SKSpriteNode?
    var ammoLabelNode: SKLabelNode?
    var bulletNum: Int = 0
    var outOfFiringRange: Bool = false
    var currentGun: guns?
    var tickUpdate = 0
    var secondaryGun: guns?
    var totalAmmoCount: [Int] = []
    var spitNodes: [SKSpriteNode] = []
    var moveStickNode: SKSpriteNode?
    var moveStickResetPos: CGPoint?
    var explodeNodes: [SKSpriteNode] = []
    var explodeTick: [Int] = []
    let info = AppDelegate()
    
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
    }
    
    struct zombieType
    {
        var speed: CGFloat
        var type: String
        var canAttack: Bool
        var animationState: Int
    }
    
    override func didMoveToView(view: SKView) {
        self.view?.showsNodeCount = true
        self.view?.showsFPS = true

        loadGuns()
        shotsRemaining = 0
        loadGameData()
        if (level == nil)
        {
            print("Error loading level")
            level = 0
        }
        //setbackground of level
        let image: UIImage = UIImage(named: "location-\((level! + 1))")!
        let texture: SKTexture = SKTexture(image: image)
        backgroundNode = SKSpriteNode(texture: texture, color: UIColor.whiteColor(), size: self.frame.size)
        backgroundNode!.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        backgroundNode!.name  = "background"
        backgroundNode?.zPosition = 1
        addChild(backgroundNode!)
        print("\(currentGun?.name)")
        
        let effectImage: UIImage = UIImage(named: "location-\(level! + 1)-effect")!
        let effectTexture: SKTexture = SKTexture(image: effectImage)
        backgroundEffectNode.append(SKSpriteNode(texture: effectTexture, color: UIColor.whiteColor(), size: self.frame.size))
        backgroundEffectNode[0].position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        backgroundEffectNode[0].zPosition = 1050
        addChild(backgroundEffectNode[0])
        backgroundEffectNode.append(SKSpriteNode(color: UIColor.clearColor(), size: CGSize(width: 0, height: 0)))
        updateEffect()
        
        //create player node
        playerNode = SKSpriteNode(texture: SKTexture(imageNamed: "PlayerStill-\(currentGun!.name)"), color: UIColor.whiteColor(), size: CGSize(width: self.frame.size.width/10, height: self.frame.height/6))
        playerNode.position = CGPoint(x: ((self.frame.size.width / 10) * 9), y: self.frame.height / 2)
        playerNode.position.x = ((self.frame.size.width / 10) * 9) - ((playerNode.position.y / 2) + 20)
        playerNode.name = "playerNode"
        playerNode.zPosition = 2000
        addChild(playerNode)
        
        ammoNode = SKSpriteNode(color: UIColor.grayColor(), size: CGSize(width: self.frame.size.width/4, height: self.frame.size.height / 10))
        ammoNode?.position = CGPoint(x: self.frame.width / 10 + self.frame.size.width/8, y: self.frame.height / 10 * 9)
        ammoNode?.name = "ammoNode"
        ammoNode?.zPosition = 2005
        addChild(ammoNode!)
        
        let backgroundAmmoNode = SKSpriteNode(color: UIColor.darkGrayColor(), size: CGSize(width: self.frame.size.width/4, height: self.frame.size.height / 10))
        backgroundAmmoNode.position = CGPoint(x: self.frame.width / 10 + self.frame.size.width/8, y: self.frame.height / 10 * 9)
        backgroundAmmoNode.name = "ammoBackgroundNode"
        backgroundAmmoNode.zPosition = 2000
        addChild(backgroundAmmoNode)
        
        
        barricadeNode = SKSpriteNode(texture: SKTexture(imageNamed: "BarricadeFull"), color: UIColor.whiteColor(), size: CGSize(width: self.frame.width / 10, height: (self.frame.height / 6) * 4))
        barricadeNode.position = CGPoint(x: (self.frame.width / 20) * 12, y: (self.frame.height / 2 - self.barricadeNode.frame.height / 4))
        barricadeNode.name = "barricadeNode"
        barricadeNode.zPosition = 1050
        addChild(barricadeNode)
        
        barricadeHealthNode = SKSpriteNode(color: UIColor.greenColor(), size: CGSize(width: self.frame.size.width / 5, height: self.frame.size.height / 10))
        barricadeHealthNode.position = CGPoint(x: self.frame.width / 2, y: ((self.frame.height / 10) * 9))
        barricadeHealthNode.zPosition = 2000
        barricadeHealthNode.name = "healthBarNode"
        addChild(barricadeHealthNode)
        
        let moveStickBackground = SKSpriteNode(color: UIColor.blackColor(), size: CGSize(width: self.frame.width/8, height: self.frame.width/8))
        moveStickBackground.position = CGPoint(x: (self.frame.width / 10) * 9, y: self.frame.height / 5)
        moveStickBackground.zPosition = 2000
        addChild(moveStickBackground)
        
        moveStickNode = SKSpriteNode(color: UIColor.whiteColor(), size: CGSize(width: self.frame.width/14, height: self.frame.width/14))
        moveStickNode?.position = moveStickBackground.position
        moveStickNode?.zPosition = 2010
        moveStickNode?.name = "moveStick"
        addChild(moveStickNode!)
        moveStickResetPos = moveStickNode?.position
        updateHealth()
        movePlayer()
        
        let switchGunNode = SKSpriteNode(color: UIColor.blackColor(), size: CGSize(width: self.frame.size.width / 6,height: self.frame.size.height / 10))
        switchGunNode.position = CGPoint(x: ((self.frame.size.width / 10) * 9), y: ((self.frame.size.height / 10) * 9))
        switchGunNode.name = "switchGun"
        switchGunNode.zPosition = 2000
        addChild(switchGunNode)
        
        guard let totalAmmoCountGet = NSUserDefaults.standardUserDefaults() .objectForKey("gunAmmoCount") as? [Int]
            else
        {
            ammoLabelNode = SKLabelNode(text: "\(shotsRemaining)/0")
            ammoLabelNode?.fontColor = UIColor.whiteColor()
            ammoLabelNode?.fontSize = (ammoNode!.size.width / 10)
            ammoLabelNode?.position = CGPoint(x: self.frame.width / 10 + self.frame.size.width/8, y: self.frame.height / 20 * 18)
            ammoLabelNode?.name = "ammoLabelNode"
            ammoLabelNode?.zPosition = 2015
            addChild(ammoLabelNode!)
            print("Error obtaining ammo for guns")
            return
        }
        totalAmmoCount = totalAmmoCountGet
        
        var ammoTypeNum = 0
        if (currentGun!.type == "Pistol")
        {ammoTypeNum = 0}
        else if (currentGun!.type == "Assault Rifle")
        {ammoTypeNum = 1}
        ammoLabelNode = SKLabelNode(text: "\(shotsRemaining)/\(totalAmmoCount[ammoTypeNum])")
        ammoLabelNode?.fontColor = UIColor.whiteColor()
        ammoLabelNode?.fontSize = (ammoNode!.size.width / 10)
        ammoLabelNode?.position = CGPoint(x: self.frame.width / 10 + self.frame.size.width/8, y: self.frame.height / 20 * 18)
        ammoLabelNode?.name = "ammoLabelNode"
        ammoLabelNode?.zPosition = 2015
        addChild(ammoLabelNode!)
        
        NSTimer.scheduledTimerWithTimeInterval(currentGun!.reloadTime, target: self, selector: "endReload", userInfo: nil, repeats: false)
        
        updateAmmo()
        createZombies()
        updateCharacterTexture()
    }
    
    func createZombies()
    {
        var zombieSpawns: [Int] = [0, 0, 0, 0, 0, 0, 0]
        let randomNum: UInt32 = (UInt32)((level! + 1) * levelStage!)
        let random = arc4random_uniform(randomNum) + 10
        numberOfZombies = (Int)(random)
        zombiesLeft = numberOfZombies
        print("Number of zombies spawned for level: \(numberOfZombies)")
        for (var i = 0; i < numberOfZombies; i++)
        {
            let ranType = (Int)(arc4random_uniform((UInt32)((level! + 1) * 5)) + 10)
            let ran = (Int)(arc4random_uniform(3) + 1)
            var node: SKSpriteNode?
            var zombieTypeName = ""
            
            if (ranType > 15 && ranType <= 18)
            {
                zombieSpawns[1]++
                zombieTypeName = "Tank"
                let texture = SKTexture(imageNamed: "zombieTank_pos_\(ran)")
                //node = SKSpriteNode(texture: texture, color: UIColor.whiteColor(), size: CGSize(width: self.frame.size.width / 8, height: self.frame.size.width / 4))
                node = SKSpriteNode(color: UIColor.brownColor(), size: CGSize(width: self.frame.size.width / 12, height: self.frame.size.width / 7))
                zombieHealth.append(300)
            }
            else if (ranType > 20 && ranType <= 22)
            {
                zombieSpawns[2]++
                zombieTypeName = "Spitter"
                let texture = SKTexture(imageNamed: "zombieSpitter_pos_\(ran)")
                //node = SKSpriteNode(texture: texture, color: UIColor.whiteColor(), size: CGSize(width: self.frame.size.width / 15, height: self.frame.size.width / 8))
                node = SKSpriteNode(color: UIColor.greenColor(), size: CGSize(width: self.frame.size.width / 18, height: self.frame.size.width / 10))
                zombieHealth.append(70)
            }
            else if (ranType > 25 && ranType <= 33)
            {
                zombieSpawns[3]++
                zombieTypeName = "Runner"
                let texture = SKTexture(imageNamed: "zombieRunner_pos_\(ran)")
                //node = SKSpriteNode(texture: texture, color: UIColor.whiteColor(), size: CGSize(width: self.frame.size.width / 15, height: self.frame.size.width / 8))
                node = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: self.frame.size.width / 15, height: self.frame.size.width / 8))
                zombieHealth.append(70)
            }
            else if (ranType > 33 && ranType <= 35)
            {
                zombieSpawns[4]++
                zombieTypeName = "Baby"
                let texture = SKTexture(imageNamed: "zombieRunner_pos_\(ran)")
                //node = SKSpriteNode(texture: texture, color: UIColor.whiteColor(), size: CGSize(width: self.frame.size.width / 15, height: self.frame.size.width / 8))
                node = SKSpriteNode(color: UIColor.blackColor(), size: CGSize(width: self.frame.size.width / 30, height: self.frame.size.width / 16))
                zombieHealth.append(50)
            }
            else if (ranType > 35 && ranType <= 36)
            {
                zombieSpawns[6]++
                zombieTypeName = "Exploder"
                let texture = SKTexture(imageNamed: "zombieExploder_pos_\(ran)")
                node = SKSpriteNode(texture: texture, color: UIColor.whiteColor(), size: CGSize(width: self.frame.size.width / 12, height: self.frame.size.width / 8))
                zombieHealth.append(125)
            }
            else if (ranType > 0 && ranType <= 0)
            {
                zombieSpawns[5]++
                zombieTypeName = "Spawner"
                let texture = SKTexture(imageNamed: "zombieSpawner_pos_\(ran)")
                //node = SKSpriteNode(texture: texture, color: UIColor.whiteColor(), size: CGSize(width: self.frame.size.width / 12, height: self.frame.size.width / 8))
                node = SKSpriteNode(color: UIColor.blueColor(), size: CGSize(width: self.frame.size.width / 12, height: self.frame.size.width / 7))
                zombieHealth.append(150)
            }
            else
            {
                zombieSpawns[0]++
                zombieTypeName = "Normal"
                let texture = SKTexture(imageNamed: "zombieNormal_pos_\(ran)")
                node = SKSpriteNode(texture: texture, color: UIColor.whiteColor(), size: CGSize(width: self.frame.size.width / 15, height: self.frame.size.width / 8))
                zombieHealth.append(100)
            }
            isZombieAttacking.append(false)
            let ranTick = arc4random_uniform(10) + 1
            zombieAnimationTick.append((Int)(ranTick))
            isZombieAnimating.append(false)

            var randomX: CGFloat = 0
            if (i < 6)
            {
                randomX = (CGFloat)(arc4random_uniform(500) + 200)
            }
            else
            {
                randomX = (CGFloat)(arc4random_uniform((UInt32)(i) * 50))
            }
            
            node!.position = CGPoint(x: -(randomX), y: (CGFloat)((arc4random_uniform((UInt32)(((self.frame.height / 6) * 4) - (playerNode.frame.height / 2)))) + (UInt32)(self.frame.height / 20)))
            node!.zPosition = (view!.frame.height - node!.position.y) + 10
            zombieNodes.append(node!)
            var maxSpeed = 0
            switch (zombieTypeName)
            {
            case "Tank":
                maxSpeed = 2
                break;
            case "Spitter":
                maxSpeed = 6
                break;
            case "Runner":
                maxSpeed = 12
                break;
            case "Baby":
                maxSpeed = 10
                break;
            case "Spawner":
                maxSpeed = 4
                break;
            case "Exploder":
                maxSpeed = 10
                break;
            default:
                maxSpeed = 8
            }
            let speedRandom: CGFloat = ((CGFloat)(arc4random_uniform((UInt32)((maxSpeed) + 1))) * 0.2) + 1
            if (speedRandom < 1)
            {
                print("A Zombie is broken.... he wont move?!?!?")
            }
            zombieClass.append(zombieType.init(speed: (speedRandom), type: zombieTypeName, canAttack: true, animationState: (Int)(ran)))
            addChild(zombieNodes[i])
        }
        print("Zombie Spawns:\nNormal: \(zombieSpawns[0])\nTank: \(zombieSpawns[1])\nSpitters: \(zombieSpawns[2])\nRunners: \(zombieSpawns[3])\nBabies: \(zombieSpawns[4])\nSpawner: \(zombieSpawns[5])\nExploder: \(zombieSpawns[6])")
    }
    
    func loadGameData()
    {
        guard let levelLoad: Int = NSUserDefaults.standardUserDefaults() .objectForKey("level") as? Int
            else {
                print("unable to load level... setting level to 0")
                setToDefault()
                return
        }
        guard let health: Double = NSUserDefaults.standardUserDefaults() .objectForKey("barricadeHealth") as? Double
            else {
                print("Unable to load barricade health... setting health to 100")
                setToDefault()
                return
        }
        guard let stageLoad: Int = NSUserDefaults.standardUserDefaults() .objectForKey("levelStage") as? Int
            else {
                print("Unable to load stageLoad... setting stage to 1")
                setToDefault()
                return
        }
        print("----------\nSave loaded:\nPlayer is on level: \(levelLoad)\nBarricade Health is currently: \(health)\n----------")
        level = levelLoad
        barricadeHealth = health
        levelStage = stageLoad
    }
    
    func setToDefault()
    {
        levelStage = 1
        level = 0
        barricadeHealth = 100
    }
    
    func saveGameData()
    {
        NSUserDefaults.standardUserDefaults() .setObject(level, forKey: "level")
        NSUserDefaults.standardUserDefaults() .setObject(barricadeHealth, forKey: "barricadeHealth")
        NSUserDefaults.standardUserDefaults() .synchronize()
        guard let _: Int = NSUserDefaults.standardUserDefaults() .objectForKey("level") as? Int
            else{
                print("Something went wrong when saving game data...\n!Unable to save game!")
                return
        }
            print("Succesfully saved game data...")
    }
    
    func updateEffect()
    {
        if (backgroundEffectNode[0].position.x == self.frame.width/2)
        {
            effectStep = true
            createEffect()
        }
        if (backgroundEffectNode[0].position.x == (self.frame.width * 1.5))
        {
            effectStep = false
            backgroundEffectNode[0].removeFromParent()
            backgroundEffectNode[0] = backgroundEffectNode[1]
            createEffect()
        }
        for (var i = 0; i < backgroundEffectNode.count; i++)
        {
            backgroundEffectNode[i].position.x += 1
        }
    }
    
    func createEffect()
    {
        let effectImage: UIImage = UIImage(named: "location-\((level! + 1))-effect")!
        let effectTexture: SKTexture = SKTexture(image: effectImage)
        backgroundEffectNode[1] = SKSpriteNode(texture: effectTexture, color: UIColor.whiteColor(), size: self.frame.size)
        backgroundEffectNode[1].position = CGPoint(x: backgroundEffectNode[0].position.x - self.frame.width, y: self.frame.size.height/2)
        backgroundEffectNode[1].zPosition = 1050
        addChild(backgroundEffectNode[1])
    }
    
    //Update game time
    override func update(currentTime: NSTimeInterval) {
        if (hasGameEnded == false)
        {
            tickUpdate++
            if (tickUpdate == 3)
            {
                tickUpdate = 0
                updateEffect()
            }
            if (movingPlayer == true)
            {
                movePlayer()
                    moveTick++
                    if (moveTick == 10)
                    {
                        moveTick = 0
                        updateCharacterAnimation()
                    }
            }
            else
            {
                if (playerAnimateState != 0)
                {
                    playerAnimateState = 0
                    updateCharacterTexture()
                }
            }
            if (spitNodes.count > 0)
            {
                updateSpitNodes()
            }
            if (shotsAt != nil)
            {
                if (allowedToFire == true)
                {
                    if ((!isReloading) && (!isPlayerMoving))
                    {
                        isFiring = true
                        updateCharacterTexture()
                    }
                    else
                    {
                        if (isFiring == true)
                        {
                            isFiring = false
                            updateCharacterTexture()
                        }
                    }
                    var ammoTypeNum = 0
                    if (currentGun!.type == "Pistol")
                    {ammoTypeNum = 0}
                    else if (currentGun!.type == "Assault Rifle")
                    {ammoTypeNum = 1}
                    if (totalAmmoCount[ammoTypeNum] > 0 || shotsRemaining > 0)
                    {
                        playerShoot(shotsAt!)
                        allowedToFire = false
                        NSTimer.scheduledTimerWithTimeInterval((currentGun?.shotSpeed)!, target: self, selector: "setFireToTrue", userInfo: nil, repeats: false)
                    }
                }
                else
                {
                    if (isFiring == true)
                    {
                        isFiring = false
                        updateCharacterTexture()
                    }
                }
            }
            else
            {
                if (isFiring == true)
                {
                    isFiring = false
                    updateCharacterTexture()
                }
            }
            moveZombies()
            if (zombiesLeft <= 0 && hasGameEnded == false)
            {
                let endNode = SKLabelNode(text: "You have survived the night...")
                endNode.fontSize = self.frame.width / 25
                endNode.zPosition = 9999
                endNode.fontColor = UIColor.whiteColor()
                endNode.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
                addChild(endNode)
                hasGameEnded = true
                NSUserDefaults.standardUserDefaults().setObject(totalAmmoCount, forKey: "gunAmmoCount")
                NSUserDefaults.standardUserDefaults() .setObject(true, forKey: "finishedLevel")
                NSUserDefaults.standardUserDefaults() .synchronize()
                NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "endGameWin", userInfo: nil, repeats: false)
            }
            for (var i = 0; i < zombiesLeft; i++)
            {
                if (isZombieAnimating[i] == false)
                {
                    isZombieAnimating[i] = true
                    updateZombieAnimation(i)
                }
                else
                {
                    zombieAnimationTick[i]++
                    if (zombieAnimationTick[i] >= 10)
                    {
                        zombieAnimationTick[i] = 0
                        isZombieAnimating[i] = false
                    }
                }
            }
            if (explodeNodes.count > 0)
            {
                for (var i = 0; i < explodeNodes.count; i++)
                {
                    explodeTick[i]++
                    if (explodeTick[i] > 23)
                    {
                        explodeNodes[i].removeFromParent()
                        for (var j = i; j < explodeNodes.count - 1; j++)
                        {
                            explodeNodes[j] = explodeNodes[j + 1]
                            explodeTick[j] = explodeTick[j + 1]
                        }
                        explodeNodes.popLast()
                        explodeTick.popLast()
                    }
                    else
                    {
                        explodeNodes[i].texture = SKTexture(imageNamed: "explosion_\(explodeTick[i])")
                    }
                }
            }
        }
        if (numberOfBullets > 0)
        {
            updateBulletPosition()
        }
        if (hasGameEnded == true)
        {
        }
    }
    
    func movePlayer()
    {
        playerNode.position.y += ((moveStickNode?.position.y)! - (moveStickResetPos?.y)!) / 7
        if (playerNode.position.y > (((self.frame.height / 6) * 4) - (playerNode.frame.height / 2)))
        {
            playerNode.position.y = (((self.frame.height / 6) * 4) - (playerNode.frame.height / 2))
        }
        else if (playerNode.position.y < ((self.frame.height / 20) + (playerNode.frame.height / 2)))
        {
            playerNode.position.y = ((self.frame.height / 20) + (playerNode.frame.height / 2))
        }

        playerNode.position.x = ((self.frame.size.width / 10) * 8) - ((playerNode.position.y / 3))
    }
    
    func updateZombieAnimation(zombieNum: Int)
    {
        if (zombieClass[zombieNum].type == "Normal" || zombieClass[zombieNum].type == "Exploder") //temp stop due to limited art
        {
            if (isZombieAttacking[zombieNum] == false)
            {
                zombieClass[zombieNum].animationState++
                if (zombieClass[zombieNum].animationState > 3)
                {
                    zombieClass[zombieNum].animationState = 1
                }
                zombieNodes[zombieNum].texture = SKTexture(imageNamed: "zombie\(zombieClass[zombieNum].type)_pos_\(zombieClass[zombieNum].animationState)")
            }
            else
            {
                zombieClass[zombieNum].animationState++
                if (zombieClass[zombieNum].animationState > 3)
                {
                    zombieClass[zombieNum].animationState = 1
                }
                zombieNodes[zombieNum].texture = SKTexture(imageNamed: "zombie\(zombieClass[zombieNum].type)_attack_\(zombieClass[zombieNum].animationState)")
            }
        }
    }
    
    func updateCharacterAnimation()
    {
        if (playerAnimateState == 0)
        {
            playerAnimateState = 1
        }
        else if (playerAnimateState == 1)
        {
            playerAnimateState = 2
        }
        else if (playerAnimateState == 2)
        {
            playerAnimateState = 3
        }
        else if (playerAnimateState == 3)
        {
            playerAnimateState = 2
        }
        updateCharacterTexture()
    }
    
    func updateCharacterTexture()
    {
        isPlayerMoving = false
        var ammoTypeNum = 0
        if (currentGun!.type == "Pistol")
        {ammoTypeNum = 0}
        else if (currentGun!.type == "Assault Rifle")
        {ammoTypeNum = 1}
        if (totalAmmoCount[ammoTypeNum] > 0 && shotsRemaining == 0)
        {
            isFiring = false
        }
        var what = 0
        if (isFiring)
        {
            what = 1
            playerNode.texture = SKTexture(imageNamed: "PlayerFire-\(currentGun!.name)")
        }
        else if (playerAnimateState == 0)
        {
            what = 2
            playerNode.texture = SKTexture(imageNamed: "PlayerStill-\(currentGun!.name)")
        }
        else
        {
            what = 3
            playerNode.texture = SKTexture(imageNamed: "PlayerMoving\(playerAnimateState)-\(currentGun!.name)")
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

        let touch = touches.first
        let point = touch!.locationInNode(self)
        let node = nodeAtPoint(point)

        if (node.name == "moveStick")
        {
            movingPlayer = true
        }
        else if (node.name == "switchGun" && isReloading == false)
        {
            if (secondaryGun != nil)
            {
                let transferGun = currentGun
                currentGun = secondaryGun
                secondaryGun = transferGun
                shotsRemaining = 0
                updateCharacterTexture()
                isReloading = true
                NSTimer.scheduledTimerWithTimeInterval(((currentGun?.reloadTime)! / 2), target: self, selector: "endReload", userInfo: nil, repeats: false)
                updateAmmo()
            }
            else
            {
                print("unable to load secondary gun as there is no secondary gun equiped...")
            }
        }
        else if ((node.name == "ammoNode" || node.name == "ammoLabelNode") && isReloading == false)
        {
            var ammoTypeNum = 0
            if (currentGun!.type == "Pistol")
            {ammoTypeNum = 0}
            else if (currentGun!.type == "Assault Rifle")
            {ammoTypeNum = 1}
            if (totalAmmoCount[ammoTypeNum] > 0)
            {
                isReloading = true
                NSTimer.scheduledTimerWithTimeInterval((currentGun?.reloadTime)!, target: self, selector: "endReload", userInfo: nil, repeats: false)
                ammoLabelNode?.text = "Reloading..."
            }
        }
        else
        {
            movingPlayer = false
            moveStickNode?.position = moveStickResetPos!
            shotsAt = point
        }
        
    }
    
    func setFireToTrue()
    {
        allowedToFire = true
        isFiring = false
        updateCharacterAnimation()
    }
    
    func endReload()
    {
        isReloading = false
        var ammoTypeNum = 0
        if (currentGun!.type == "Pistol")
        {ammoTypeNum = 0}
        else if (currentGun!.type == "Assault Rifle")
        {ammoTypeNum = 1}
        if (totalAmmoCount[ammoTypeNum] > 0)
        {
            if (totalAmmoCount[ammoTypeNum] < currentGun!.ammoClip)
            {
                shotsRemaining = totalAmmoCount[ammoTypeNum]
                totalAmmoCount[ammoTypeNum] = 0
            }
            else
            {
                totalAmmoCount[ammoTypeNum] -= currentGun!.ammoClip
                shotsRemaining = (currentGun?.ammoClip)!
            }
            updateAmmo()
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let point = touch?.locationInNode(self)
        if (shotsAt != nil)
        {
            shotsAt = point
        }
        if (movingPlayer == true)
        {
            moveStickNode?.position.y = (point?.y)!
            if (moveStickNode?.position.y > ((moveStickResetPos?.y)! * 1.3))
            {
                moveStickNode?.position.y = ((moveStickResetPos?.y)! * 1.3)
            }
            else if (moveStickNode?.position.y < (moveStickResetPos!.y * 0.75))
            {
                moveStickNode?.position.y = moveStickResetPos!.y * 0.75
            }
            moveStickNode?.position.x = moveStickResetPos!.x
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let point = touch?.locationInNode(self)
        if (shotsAt != nil)
        {
            shotsAt = nil
        }
        if (movingPlayer == true)
        {
            moveStickNode?.position = moveStickResetPos!
            movingPlayer = false
        }

    }

    
    func playerShoot(point: CGPoint)
    {
        updateAmmo()
        if (shotsRemaining <= 0 && isReloading == false)
        {
            var ammoTypeNum = 0
            if (currentGun!.type == "Pistol")
            {ammoTypeNum = 0}
            else if (currentGun!.type == "Assault Rifle")
            {ammoTypeNum = 1}
            if (totalAmmoCount[ammoTypeNum] > 0)
            {
                isReloading = true
                NSTimer.scheduledTimerWithTimeInterval((currentGun?.reloadTime)!, target: self, selector: "endReload", userInfo: nil, repeats: false)
                ammoLabelNode?.text = "Reloading..."
            }
        }

        if (isReloading == true)
        {
            //RELOADING!
        }
        else
        {
            let vecX = (point.x - playerNode.position.x)
            let vecY = (point.y - playerNode.position.y)
            let vecAngle = atan2(vecX, vecY)
            if (vecAngle <= -1.3 && vecAngle >= -1.85)
            {
                let bulletTexture = SKTexture(imageNamed: "bullet_\(currentGun!.type)")
                bulletNode.append(SKSpriteNode(texture: bulletTexture, color: UIColor.whiteColor(), size: CGSize(width: playerNode.frame.width / 12, height: playerNode.frame.width / 15)))
                bulletNode[numberOfBullets].position = CGPoint(x: playerNode.position.x - playerNode.frame.width / 2, y: playerNode.position.y + playerNode.frame.height / 4)
                bulletNode[numberOfBullets].name = "bulletNode\(numberOfBullets)"
                bulletNode[numberOfBullets].zPosition = 5;
                //calculating bullet spread
                var randomOffY: CGFloat = (CGFloat)(arc4random_uniform((UInt32)((currentGun?.spread)!)))
                if (arc4random_uniform(2) == 1)
                {
                    randomOffY -= (randomOffY * 2)
                }
            
                let finalX = sin(vecAngle) * (CGFloat)((currentGun?.velocity)!)
                let finalY = (cos(vecAngle) * (CGFloat)((currentGun?.velocity)!)) + randomOffY
            
                let vec = CGPoint(x: finalX, y: finalY)
                bulletFireTo.append(vec)
                bulletIsActive.append(true)
                addChild(bulletNode[numberOfBullets])
                numberOfBullets++
                shotsRemaining--
                outOfFiringRange = false
            }
            else
            {
                outOfFiringRange = true
                isFiring = false
            }
        }
    }
    
    
    func updateBulletPosition()
    {
        for (var i = 0; i < numberOfBullets; i++)
        {
            for (var j = 0; j < 10; j++)
            {
                bulletNode[i].position.x += (bulletFireTo[i].x / 10)
                bulletNode[i].position.y += (bulletFireTo[i].y / 10)
                bulletCollision()
            }
            if (bulletNode[i].position.x <= -(self.frame.width / 10))
            {
                removeBulletAt(i)
            }
        }
    }
    
    func bulletCollision()
    {
        for (var i = 0; i < numberOfBullets; i++)
        {
            if (bulletIsActive[i])
            {
                for (var j = 0; j < numberOfZombies; j++)
                {
                    if (bulletNode[i].intersectsNode(zombieNodes[j]))
                    {
                            if (bulletNode[i].position.y >= (zombieNodes[j].position.y + zombieNodes[j].frame.height / 4))
                            {
                                zombieHealth[j] -= ((currentGun?.damage)! * 2)
                            }
                            else
                            {
                                zombieHealth[j] -= (currentGun?.damage)!
                            }
                            createBloodSplatter(bulletNode[i].position)
                            bulletNode[i].removeFromParent()
                            bulletIsActive[i] = false
                            if (zombieHealth[j] <= 0)
                            {
                                if (zombieClass[j].type == "Spawner")
                                {
                                    let ranNum = arc4random_uniform(3)
                                    removeZombieAt(j)
                                    zombiesLeft--
                                    for (var b = 0; b < (Int)(ranNum + 3); b++)
                                    {
                                        let ranY: CGFloat = (CGFloat)(arc4random_uniform(80) + 1)
                                        let zombieTypeName = "Normal"
                                        let ran = arc4random_uniform(3) + 1
                                        let texture = SKTexture(imageNamed: "zombieNormal_pos_\(ran)")
                                        let node = SKSpriteNode(texture: texture, color: UIColor.whiteColor(), size: CGSize(width: self.frame.size.width / 15, height: self.frame.size.width / 8))
                                        zombieHealth.append(100)
                                        isZombieAttacking.append(false)
                                        let ranTick = arc4random_uniform(10) + 1
                                        zombieAnimationTick.append((Int)(ranTick))
                                        isZombieAnimating.append(false)
                                        let ranChange: CGFloat = zombieNodes[j].position.y + (ranY - 40)
                                        node.position = CGPoint(x: zombieNodes[j].position.x, y: ranChange)
                                        node.zPosition = (view!.frame.height - node.position.y) + 10
                                        zombieNodes.append(node)
                                        let speedRandom: CGFloat = ((CGFloat)(arc4random_uniform((UInt32)((10) + 1))) * 0.2) + 1
                                        if (speedRandom < 1)
                                        {
                                            print("A Spawned in zombie can't move?")
                                        }
                                        zombieClass.append(zombieType.init(speed: (speedRandom), type: zombieTypeName, canAttack: true, animationState: (Int)(ran)))
                                        addChild(zombieNodes[(zombieNodes.count - 1)])
                                        zombiesLeft++
                                    }
                                }
                                if (zombieClass[j].type == "Exploder")
                                {
                                    explodeAtPos(zombieNodes[j].position)
                                    let explodePos = zombieNodes[j].position
                                    removeZombieAt(j)
                                    zombiesLeft--
                                    explodeAtPos(explodePos)
                                    for (var a = 0; a < zombieNodes.count; a++)
                                    {
                                        if ((zombieNodes[a].position.x >= explodePos.x + self.frame.width / 8 && zombieNodes[a].position.x <= explodePos.x - self.frame.width / 8) || (zombieNodes[a].position.y >= explodePos.y + self.frame.width / 8 && zombieNodes[a].position.y <= explodePos.y - self.frame.width / 8))
                                        {
                                            zombieHealth[a] -= 50
                                            if (zombieHealth[a] <= 0)
                                            {
                                                removeZombieAt(a)
                                                zombiesLeft--
                                            }
                                        }
                                    }
                                }
                                else
                                {
                                    //zombie death animation
                                    removeZombieAt(j)
                                    zombiesLeft--
                                }
                            }
                    }

                }
            }
        }
    }
    
    func createMoreZombies(spawnPoint: CGPoint, numberToSpawn: Int)
    {
        for (var i = 0; i < numberToSpawn; i++)
        {
            let ran = (Int)(arc4random_uniform(3) + 1)
            var node: SKSpriteNode?
            var zombieTypeName = ""
    
            zombieTypeName = "Normal"
            let texture = SKTexture(imageNamed: "zombieNormal_pos_\(ran)")
            node = SKSpriteNode(texture: texture, color: UIColor.whiteColor(), size: CGSize(width: self.frame.size.width / 15, height: self.frame.size.width / 8))
            zombieHealth.append(100)
            
            isZombieAttacking.append(false)
            let ranTick = arc4random_uniform(10) + 1
            zombieAnimationTick.append((Int)(ranTick))
            isZombieAnimating.append(false)
            
            let randomX: CGFloat = spawnPoint.x - (CGFloat)(arc4random_uniform((UInt32)(self.frame.width/30)))
            let randomY: CGFloat = spawnPoint.y - ((CGFloat)(arc4random_uniform((UInt32)(self.frame.width/100))) - 50)
            node!.position = CGPoint(x: -(randomX), y: randomY)
            node!.zPosition = (view!.frame.height - node!.position.y) + 10
            zombieNodes.append(node!)
            let maxSpeed = 8
            let speedRandom: CGFloat = ((CGFloat)(arc4random_uniform((UInt32)((maxSpeed) + 1))) * 0.2) + 1
            zombieClass.append(zombieType.init(speed: (speedRandom), type: zombieTypeName, canAttack: true, animationState: (Int)(ran)))
            zombieNodes.append(node!)
            addChild(zombieNodes[zombieNodes.count - 1])
        }
        print("\(numberToSpawn) More Zombies Spawned in @ Spawner pos (\(spawnPoint))")
    }

    func createBloodSplatter(pos: CGPoint)
    {
        let ran = arc4random_uniform(1) + 1
        let texture = SKTexture(imageNamed: "bloodHit\(ran)")
        bloodSplatter.append(SKSpriteNode(texture: texture, color: UIColor.whiteColor(), size: CGSize(width: playerNode.frame.width / 6, height: playerNode.frame.width / 6)))
        bloodSplatter[bloodSplatter.count - 1].position = pos
        bloodSplatter[bloodSplatter.count - 1].zPosition = 6
        addChild(bloodSplatter[bloodSplatter.count - 1])
        NSTimer.scheduledTimerWithTimeInterval(0.02, target: self, selector: "removeBloodSplatter", userInfo: nil, repeats: false)
    }
    
    func removeBloodSplatter()
    {
        bloodSplatter[0].removeFromParent()
        for (var i = 0; i < bloodSplatter.count - 1; i++)
        {
            bloodSplatter[i] = bloodSplatter[i + 1]
        }
        bloodSplatter.popLast()
    }
    
    func updateHealth()
    {
        barricadeHealthNode.size.width = (((self.frame.width / 5) / 100) * (CGFloat)(barricadeHealth!))
        if (barricadeHealth <= 25)
        {
            barricadeHealthNode.color = UIColor.redColor()
        }
        else if (barricadeHealth <= 60)
        {
            barricadeHealthNode.color = UIColor.orangeColor()
        }
        else
        {
            barricadeHealthNode.color = UIColor.greenColor()
        }
        if (barricadeHealth <= 0 && hasGameEnded == false)
        {
            hasGameEnded = true
            let endNode = SKLabelNode(text: "You have been killed....")
            endNode.fontSize = self.frame.width / 25
            endNode.zPosition = 9999
            endNode.fontColor = UIColor.whiteColor()
            endNode.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
            addChild(endNode)
            hasGameEnded = true
            NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "endGameLose", userInfo: nil, repeats: false)
            info.playerLost = true
        }
    }
    
    func removeHealth(healthDown: Double)
    {
        barricadeHealth! -= healthDown
        updateHealth()
    }
    
    func moveZombies()
    {
        for (var i = 0; i < numberOfZombies; i++)
        {
            if (zombieClass[i].type == "Tank")
            {
                if (zombieNodes[i].position.x >= ((self.barricadeNode.position.x - (self.barricadeNode.frame.width / 2)) - (self.zombieNodes[i].position.y / 10)))
                {
                    isZombieAttacking[i] = true
                    removeHealth((Double)((3 - (zombieClass[i].speed)) * 0.02))
                }
                else
                {
                    isZombieAttacking[i] = false
                }
            }
            else if (zombieClass[i].type == "Spitter")
            {
                if (zombieNodes[i].position.x >= ((self.view?.frame.width)! / 2 - self.barricadeNode.frame.width))
                {
                    isZombieAttacking[i] = true
                    let ran = arc4random_uniform(40) + 1
                    if (ran == 1)
                    {
                        fireSpit(zombieNodes[i].position)
                    }
                }
                else
                {
                    isZombieAttacking[i] = false
                }
            }
            else if (zombieClass[i].type == "Exploder")
            {
                if (zombieNodes[i].position.x >= ((self.barricadeNode.position.x - (self.barricadeNode.frame.width / 2)) - (self.zombieNodes[i].position.y / 10)))
                {
                    isZombieAttacking[i] = true
                    let ran = arc4random_uniform(3) + 1
                    removeHealth((Double)(ran * 10))
                    explodeAtPos(zombieNodes[i].position)
                    removeZombieAt(i)
                    zombiesLeft--
                }
                else
                {
                    isZombieAttacking[i] = false
                }
            }
            else
            {
                if (zombieNodes[i].position.x >= ((self.barricadeNode.position.x - (self.barricadeNode.frame.width / 2)) - (self.zombieNodes[i].position.y / 10)))
                {
                    isZombieAttacking[i] = true
                    removeHealth((Double)((3 - (zombieClass[i].speed)) * 0.01))
                }
                else
                {
                    isZombieAttacking[i] = false
                }
            }
            if (isZombieAttacking[i] == false)
            {
                zombieNodes[i].position.x += zombieClass[i].speed
            }
        }
    }
    
    func explodeAtPos(point: CGPoint)
    {
        let texture = SKTexture(imageNamed: "explosion_1")
        let node = SKSpriteNode(texture: texture, color: UIColor.whiteColor(), size: CGSize(width: self.frame.width / 4, height: self.frame.width / 4))
        node.position = point
        node.zPosition = 1500
        explodeTick.append(1)
        explodeNodes.append(node)
        addChild(node)
    }
    
    func fireSpit(location: CGPoint)
    {
        let spitNode = SKSpriteNode(color: UIColor.blackColor(), size: CGSize(width: self.view!.frame.width / 20, height: self.view!.frame.width/20))
        spitNode.position = location
        spitNode.zPosition = 1500
        spitNodes.append(spitNode)
        addChild(spitNode)
    }

    func updateSpitNodes()
    {
        for (var i = 0; i < spitNodes.count; i++)
        {
            spitNodes[i].position.x += self.frame.width/20
            if (spitNodes[i].position.x >= barricadeNode.position.x)
            {
                spitNodes[i].removeFromParent()
                for (var j = i; j < spitNodes.count - 1; j++)
                {
                    spitNodes[j] = spitNodes[j + 1]
                }
                spitNodes.popLast()
                let ranHurt: Double = (Double)(arc4random_uniform(50) + 1) * 0.1
                barricadeHealth! -= ranHurt
                updateHealth()
            }
        }
    }
    
    func endGameWin()
    {
        saveGameData()
        self.viewController?.navigationController?.popToRootViewControllerAnimated(true)
        removeEverything()
    }
    func endGameLose()
    {
        NSUserDefaults.standardUserDefaults() .setObject(0, forKey: "level")
        NSUserDefaults.standardUserDefaults() .setObject(100, forKey: "barricadeHealth")
        NSUserDefaults.standardUserDefaults() .synchronize()
        print("Player has lost!")
        self.viewController?.navigationController?.popToRootViewControllerAnimated(true)
        removeEverything()
    }
    
    func removeZombieAt(number: Int)
    {
        zombieNodes[number].removeFromParent()
        for (var r = number; r < numberOfZombies; r++)
        {
            if (r == numberOfZombies - 1)
            {
                zombieNodes.popLast()
                zombieHealth.popLast()
                zombieClass.popLast()
            }
            else
            {
                zombieNodes[r] = zombieNodes[r + 1]
                zombieClass[r] = zombieClass[r + 1]
                zombieHealth[r] = zombieHealth[r + 1]
            }
        }
        numberOfZombies--
    }
    
    func removeBulletAt(number: Int)
    {
        for (var r = number; r < numberOfBullets; r++)
        {
            if (r == numberOfBullets - 1)
            {
                //nothing
                bulletNode.popLast()
                bulletFireTo.popLast()
                bulletIsActive.popLast()
            }
            else
            {
                bulletNode[r] = bulletNode[r + 1]
                bulletFireTo[r] = bulletFireTo[r + 1]
                bulletIsActive[r] = bulletIsActive[r + 1]
            }
        }
        numberOfBullets--
    }
    func removeEverything()
    {
        for (var i = 0; i < numberOfZombies; i++)
        {
            zombieNodes[numberOfZombies - (i + 1)].removeFromParent()
            zombieNodes.popLast()
            zombieClass.popLast()
            zombieHealth.popLast()
            numberOfZombies = 0
        }
        for (var i = 0; i < numberOfBullets; i++)
        {
            bulletNode[numberOfBullets - (i + 1)].removeFromParent()
            bulletNode.popLast()
            bulletIsActive.popLast()
            bulletFireTo.popLast()
        }
        playerNode.removeFromParent()
        barricadeHealthNode.removeFromParent()
        backgroundNode?.removeFromParent()
        barricadeNode.removeFromParent()
        backgroundEffectNode[0].removeFromParent()
        backgroundEffectNode[1].removeFromParent()
        self .removeAllActions()
        self .removeAllChildren()
        self .removeFromParent()
    }
    
    func updateAmmo()
    {
        var ammoTypeNum = 0
        if (currentGun!.type == "Pistol")
        {ammoTypeNum = 0}
        else if (currentGun!.type == "Assault Rifle")
        {ammoTypeNum = 1}
        ammoLabelNode?.text = "\(shotsRemaining)/\(totalAmmoCount[ammoTypeNum])"
        if (totalAmmoCount[ammoTypeNum] <= 0 && shotsRemaining == 0)
        {
            ammoLabelNode?.text = "Out of Ammo"
        }
        else if (shotsRemaining <= 0)
        {ammoLabelNode?.text = "Reloading..."
        shotsRemaining = 0}
        let thing: CGFloat = (CGFloat)(shotsRemaining)/(CGFloat)(currentGun!.ammoClip)
        ammoNode?.size.width = ((self.frame.size.width/4) * thing)
        ammoNode?.position.x = (self.frame.width / 10 + self.frame.size.width/8) - (((self.frame.size.width/4) - ammoNode!.size.width) / 2)
    }
    
    //-----Loading-----
    func loadGuns()
    {
        let gunName: [String] = loadString("gunName")
        let gunType: [String] = loadString("gunType")
        let gunDamage: [Double] = loadDouble("gunDamage")
        let gunVelocity: [Double] = loadDouble("gunVelocity")
        let gunSpread: [Double] = loadDouble("gunSpread")
        let gunShotSpeed: [Double] = loadDouble("gunShotSpeed")
        let gunAmmo: [Double] = loadDouble("gunAmmo")
        let gunReload: [Double] = loadDouble("gunReload")
        var descoveredGuns: [guns] = []
        for (var i = 0; i < gunName.count; i++)
        {
            descoveredGuns.append(guns.init(name: gunName[i], type: gunType[i], damage: gunDamage[i], velocity: gunVelocity[i], spread: gunSpread[i], shotSpeed: gunShotSpeed[i], ammoClip: (Int)(gunAmmo[i]), reloadTime: gunReload[i]))
        }
        
        let curGun1 = loadGunSlot("gunSlot1")
        let curGun2 = loadGunSlot("gunSlot2")
        
        if (curGun1 >= 0)
        {
            currentGun = descoveredGuns[curGun1]
        }
        if (curGun2 >= 0)
        {
            secondaryGun = descoveredGuns[curGun2]
        }
        if (currentGun == nil && secondaryGun != nil)
        {
            currentGun = secondaryGun
            secondaryGun = nil
        }
        if (currentGun == nil && secondaryGun == nil)
        {
            currentGun = guns.init(name: "pistolDefault", type: "pistol", damage: 20, velocity: 100, spread: 2, shotSpeed: 0.3, ammoClip: 10, reloadTime: 2.5)
            print("No guns equiped? Backup pistol equiped...")
        }
        
        print("Loaded gun slot 1: [\(currentGun)]")
        print("Loaded gun slot 2: [\(secondaryGun)]")

        print("Completed Gun Load...")
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
    
}
