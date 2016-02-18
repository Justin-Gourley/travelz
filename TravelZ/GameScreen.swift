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

    
    var color: [UIColor] = [UIColor.redColor(), UIColor.blueColor(), UIColor.brownColor(), UIColor.yellowColor(), UIColor.whiteColor()]
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
    var zombiesLeft = 0
    var viewController: UIViewController?
    var hasGameEnded = false
    var barricadeNode: SKSpriteNode!
    var barricadeHealth: Double?
    var barricadeHealthNode: SKSpriteNode!
    var setAttackBack: [Int] = []
    var backgroundNode: SKSpriteNode?
    var ammoNode: SKSpriteNode?
    var ammoLabelNode: SKLabelNode?
    var bulletNum: Int = 0
    var outOfFiringRange: Bool = false
    var currentGun: guns?
    var secondaryGun: guns?
    
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
        shotsRemaining = (currentGun?.ammoClip)!
        loadGameData()
        if (level == nil)
        {
            print("Error loading level")
            level = 0
        }
        //setbackground of level
        if (level == 0)
        {
            let image: UIImage = UIImage(named: "location1")!
            let texture: SKTexture = SKTexture(image: image)
            backgroundNode = SKSpriteNode(texture: texture, color: UIColor.whiteColor(), size: self.frame.size)
        }
        else
        {
            backgroundNode = SKSpriteNode(color: color[level!], size: self.frame.size)
        }
        backgroundNode!.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        backgroundNode!.name  = "background"
        backgroundNode?.zPosition = 1
        addChild(backgroundNode!)
        print("\(currentGun?.name)")
        
        //create player node
        playerNode = SKSpriteNode(texture: SKTexture(imageNamed: "PlayerStill-\(currentGun!.name)"), color: UIColor.whiteColor(), size: CGSize(width: self.frame.size.width/10, height: self.frame.height/6))
        playerNode.position = CGPoint(x: ((self.frame.size.width / 10) * 9), y: self.frame.height / 2)
        playerNode.position.x = ((self.frame.size.width / 10) * 9) - ((playerNode.position.y / 2) + 20)
        playerNode.name = "playerNode"
        playerNode.zPosition = 1000
        addChild(playerNode)
        
        ammoNode = SKSpriteNode(color: UIColor.grayColor(), size: CGSize(width: self.frame.size.width/4, height: self.frame.size.height / 10))
        ammoNode?.position = CGPoint(x: self.frame.width / 10 + self.frame.size.width/8, y: self.frame.height / 10 * 9)
        ammoNode?.name = "ammoNode"
        ammoNode?.zPosition = 1011
        addChild(ammoNode!)
        updateAmmo()
        
        let backgroundAmmoNode = SKSpriteNode(color: UIColor.darkGrayColor(), size: CGSize(width: self.frame.size.width/4, height: self.frame.size.height / 10))
        backgroundAmmoNode.position = CGPoint(x: self.frame.width / 10 + self.frame.size.width/8, y: self.frame.height / 10 * 9)
        backgroundAmmoNode.name = "ammoBackgroundNode"
        backgroundAmmoNode.zPosition = 1010
        addChild(backgroundAmmoNode)
        
        ammoLabelNode = SKLabelNode(text: "\(shotsRemaining)/\(currentGun!.ammoClip)")
        ammoLabelNode?.fontColor = UIColor.whiteColor()
        ammoLabelNode?.fontSize = (ammoNode!.size.width / 10)
        ammoLabelNode?.position = CGPoint(x: self.frame.width / 10 + self.frame.size.width/8, y: self.frame.height / 20 * 18)
        ammoLabelNode?.name = "ammoLabelNode"
        ammoLabelNode?.zPosition = 1015
        addChild(ammoLabelNode!)
        
        
        barricadeNode = SKSpriteNode(texture: SKTexture(imageNamed: "BarricadeFull"), color: UIColor.whiteColor(), size: CGSize(width: self.frame.width / 10, height: (self.frame.height / 6) * 4))
        barricadeNode.position = CGPoint(x: (self.frame.width / 20) * 12, y: (self.frame.height / 2 - self.barricadeNode.frame.height / 4))
        barricadeNode.name = "barricadeNode"
        barricadeNode.zPosition = 1000
        addChild(barricadeNode)
        
        barricadeHealthNode = SKSpriteNode(color: UIColor.greenColor(), size: CGSize(width: self.frame.size.width / 5, height: self.frame.size.height / 10))
        barricadeHealthNode.position = CGPoint(x: self.frame.width / 2, y: ((self.frame.height / 10) * 9))
        barricadeHealthNode.zPosition = 1500
        barricadeHealthNode.name = "healthBarNode"
        addChild(barricadeHealthNode)
        
        updateHealth()
        
        let switchGunNode = SKSpriteNode(color: UIColor.blackColor(), size: CGSize(width: self.frame.size.width / 6,height: self.frame.size.height / 10))
        switchGunNode.position = CGPoint(x: ((self.frame.size.width / 10) * 9), y: ((self.frame.size.height / 10) * 9))
        switchGunNode.name = "switchGun"
        switchGunNode.zPosition = 1000
        addChild(switchGunNode)
        
        createZombies()
        updateCharacterTexture()
    }
    
    func createZombies()
    {
        let randomNum: UInt32 = (UInt32)((level! + 1) * levelStage!)
        let random = arc4random_uniform(randomNum) + 10
        numberOfZombies = (Int)(random)
        zombiesLeft = numberOfZombies
        print("Number of zombies spawned for level: \(numberOfZombies)")
        for (var i = 0; i < numberOfZombies; i++)
        {
            zombieHealth.append(100)
            isZombieAttacking.append(false)
            let ranTick = arc4random_uniform(10) + 1
            zombieAnimationTick.append((Int)(ranTick))
            isZombieAnimating.append(false)
            let ran = (Int)(arc4random_uniform(3) + 1)
            let texture = SKTexture(imageNamed: "zombie_pos_\(ran)")
            let node = SKSpriteNode(texture: texture, color: UIColor.whiteColor(), size: CGSize(width: self.frame.size.width / 15, height: self.frame.size.width / 8))
            var randomX: CGFloat = 0
            if (i < 6)
            {
                randomX = (CGFloat)(arc4random_uniform(500) + 200)
            }
            else
            {
                randomX = (CGFloat)(arc4random_uniform((UInt32)(i) * 50))
            }
            node.position = CGPoint(x: -(randomX), y: (CGFloat)((arc4random_uniform((UInt32)(((self.frame.height / 6) * 4) - (playerNode.frame.height / 2)))) + (UInt32)(self.frame.height / 20)))
            node.zPosition = (view!.frame.height - node.position.y) + 10
            zombieNodes.append(node)
            let speedRandom = arc4random_uniform(2) + 1
            if (speedRandom < 1)
            {
                print("A Zombie is broken.... he wont move?!?!?")
            }
            zombieClass.append(zombieType.init(speed: (CGFloat)(speedRandom), type: "normal", canAttack: true, animationState: (Int)(ran)))
            addChild(zombieNodes[i])
        }
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
    
    //Update game time
    override func update(currentTime: NSTimeInterval) {
        if (hasGameEnded == false)
        {
            if (numberOfBullets > 0)
            {
                updateBulletPosition()
            }
            if (shotsAt != nil)
            {
                if (allowedToFire == true)
                {
                    if ((!isReloading) && (!isPlayerMoving))
                    {
                        isFiring = true
                        updateCharacterAnimation()
                    }
                    else
                    {
                        if (isFiring == true)
                        {
                            isFiring = false
                            updateCharacterAnimation()
                        }
                    }
                    playerShoot(shotsAt!)
                    allowedToFire = false
                    NSTimer.scheduledTimerWithTimeInterval((currentGun?.shotSpeed)!, target: self, selector: "setFireToTrue", userInfo: nil, repeats: false)
                }
                else
                {
                    if (isFiring == true)
                    {
                        isFiring = false
                        updateCharacterAnimation()
                    }
                }
            }
            else
            {
                if (isFiring == true)
                {
                    isFiring = false
                    updateCharacterAnimation()
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
            if (movingPlayer == true)
            {
                if (isPlayerMoving == true)
                {
                    //do nothing
                }
                else
                {
                    isPlayerMoving = true
                    NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "updateCharacterAnimation", userInfo: nil, repeats: false)
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
        }
        if (hasGameEnded == true)
        {
        }
    }
    
    func updateZombieAnimation(zombieNum: Int)
    {
        if (isZombieAttacking[zombieNum] == false)
        {
            zombieClass[zombieNum].animationState++
            if (zombieClass[zombieNum].animationState > 3)
            {
                zombieClass[zombieNum].animationState = 1
            }
            zombieNodes[zombieNum].texture = SKTexture(imageNamed: "zombie_pos_\(zombieClass[zombieNum].animationState)")
        }
        else
        {
            zombieClass[zombieNum].animationState++
            if (zombieClass[zombieNum].animationState > 3)
            {
                zombieClass[zombieNum].animationState = 1
            }
            zombieNodes[zombieNum].texture = SKTexture(imageNamed: "zombie_attack_\(zombieClass[zombieNum].animationState)")
        }
    }
    
    func updateCharacterAnimation()
    {
        if (isFiring == true && outOfFiringRange == false)
        {
            if (isFiringPic)
            {
                isFiringPic = false
            }
            else
            {
                isFiringPic = true
            }
        }
        else if (playerAnimateState == 0)
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
        if (isFiring)
        {
            playerNode.texture = SKTexture(imageNamed: "PlayerFire-\(currentGun!.name)")
        }
        else if (playerAnimateState == 0)
        {
            playerNode.texture = SKTexture(imageNamed: "PlayerStill-\(currentGun!.name)")
        }
        else
        {
            playerNode.texture = SKTexture(imageNamed: "PlayerMoving\(playerAnimateState)-\(currentGun!.name)")
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

        let touch = touches.first
        let point = touch!.locationInNode(self)
        let node = nodeAtPoint(point)

        if (node.name == "playerNode")
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
                NSTimer.scheduledTimerWithTimeInterval((currentGun?.reloadTime)!, target: self, selector: "endReload", userInfo: nil, repeats: false)
                updateAmmo()
            }
            else
            {
                print("unable to load secondary gun as there is no secondary gun equiped...")
            }
        }
        else if ((node.name == "ammoNode" || node.name == "ammoLabelNode") && isReloading == false)
        {
            isReloading = true
            NSTimer.scheduledTimerWithTimeInterval((currentGun?.reloadTime)!, target: self, selector: "endReload", userInfo: nil, repeats: false)
            ammoLabelNode?.text = "Reloading..."
        }
        else
        {
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
        shotsRemaining = (currentGun?.ammoClip)!
        updateAmmo()
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
            if (point?.y > (((self.frame.height / 6) * 4) - (playerNode.frame.height / 2)))
            {
                playerNode.position.y = (((self.frame.height / 6) * 4) - (playerNode.frame.height / 2))
            }
            else if (point?.y < ((self.frame.height / 20) + (playerNode.frame.height / 2)))
            {
                playerNode.position.y = ((self.frame.height / 20) + (playerNode.frame.height / 2))
            }
            else
            {
                playerNode.position.y = (point?.y)!
            }
            playerNode.position.x = ((self.frame.size.width / 10) * 9) - ((playerNode.position.y / 2) + 20)
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
            movingPlayer = false
        }

    }

    
    func playerShoot(point: CGPoint)
    {
        updateAmmo()
        if (shotsRemaining <= 0 && isReloading == false)
        {
            isReloading = true
            NSTimer.scheduledTimerWithTimeInterval((currentGun?.reloadTime)!, target: self, selector: "endReload", userInfo: nil, repeats: false)
            ammoLabelNode?.text = "Reloading..."
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
            print(vecAngle)
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
                                removeZombieAt(j)
                                zombiesLeft--
                            }
                    }

                }
            }
        }
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
            endGameLose()
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
            if (zombieNodes[i].position.x >= ((self.barricadeNode.position.x - (self.barricadeNode.frame.width / 2)) - (self.zombieNodes[i].position.y / 10)))
            {
                isZombieAttacking[i] = true
                    removeHealth((Double)((3 - (zombieClass[i].speed)) * 0.01))
            }
            else
            {
                zombieNodes[i].position.x += zombieClass[i].speed
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
    }
    
    func updateAmmo()
    {
        ammoLabelNode?.text = "\(shotsRemaining)/\(currentGun!.ammoClip)"
        if (shotsRemaining <= 0)
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
