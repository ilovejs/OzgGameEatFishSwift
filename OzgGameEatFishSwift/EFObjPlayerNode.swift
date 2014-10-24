
import Foundation
import SpriteKit

class EFObjPlayerNode: EFObjBaseFishNode {
    
    enum Status {
        case Small
        case Normal
        case Big
    }
    
    var m_status: Status?
    var m_isInvincible: Bool?
    
    override init() {
        super.init()
        
        self.m_animSpriteList = EFObjFishData.playerFish()
        self.m_isMoving = false
        self.m_status = Status.Small
        self.m_isInvincible = false
        
        var fishTex = NSBundle.mainBundle().pathForResource((self.m_animSpriteList?[0].stringByDeletingPathExtension)!, ofType: self.m_animSpriteList?[0].pathExtension)!
        
        var fish = SKSpriteNode(texture: OzgSKTextureManager.getInstance!.get(fishTex))
        fish.position = CGPoint.zeroPoint
        fish.name = "fish"
        fish.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(16, 16))
        fish.physicsBody?.dynamic = true
        fish.physicsBody?.allowsRotation = false
        fish.physicsBody?.friction = 0
        fish.physicsBody?.restitution = 1
        fish.physicsBody?.linearDamping = 0
        fish.physicsBody?.collisionBitMask = 0
        fish.physicsBody?.contactTestBitMask = 1
        fish.physicsBody?.categoryBitMask = 1        
        self.addChild(fish)
        
//        var testPhysics = SKShapeNode(rect: CGRectMake(0, 0, 16, 16))
//        testPhysics.fillColor = UIColor.blackColor()
//        testPhysics.zPosition = 5
//        testPhysics.position = CGPointMake(0, 0)
//        self.addChild(testPhysics)
        
        self.changeStatus(self.m_status!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
        println("EFObjPlayerNode释放")
    }
    
    func changeStatus(status: Status) {
        self.m_status = status
        
        var water = self.childNodeWithName("water") as SKSpriteNode?
        
        switch self.m_status! {
        
        case Status.Normal:
            self.m_animSpriteList = EFObjFishData.playerMFish()
            
            water?.setScale(10.0)
            
        case Status.Big:
            self.m_animSpriteList = EFObjFishData.playerBFish()
            
            water?.setScale(15.0)
            
        default:
            self.m_animSpriteList = EFObjFishData.playerFish()
            
            water?.setScale(5.0)
            
        }
        
        self.playAnim()
    }
    
    func invincible() {
        self.m_isInvincible = true
        
        var fish = self.childNodeWithName("fish") as SKSpriteNode?
        
        //水泡
        var water = self.childNodeWithName("water") as SKSpriteNode?
        if water == nil {
            var waterTex = NSBundle.mainBundle().pathForResource("Fishtales/water1", ofType: "png")!
            water = SKSpriteNode(texture: OzgSKTextureManager.getInstance!.get(waterTex))
            water?.position = CGPoint.zeroPoint
            water?.setScale(5.0)
            water?.name = "water"
            self.addChild(water!)
            
            (water?)!.runAction(SKAction.waitForDuration(GameConfig.invincibleTime), completion: {
                self.m_isInvincible = false
                (water?)!.removeFromParent()
            })
            
        }
        
    }
    
    func invincible2() {
        //暂时没有使用这个方法
        
    }
    
    func cump(type: EFObjEnemyFishNode.EnemyFishType) {
        
        var scoreEffectStr = ""
        
        switch type {
        
        case EFObjEnemyFishNode.EnemyFishType.Fish2:
            scoreEffectStr = scoreEffectStr.stringByAppendingFormat("+%i", GameConfig.scoreFish2)
            
        case EFObjEnemyFishNode.EnemyFishType.Fish3:
            scoreEffectStr = scoreEffectStr.stringByAppendingFormat("+%i", GameConfig.scoreFish3)
            
        case EFObjEnemyFishNode.EnemyFishType.Fish4:
            scoreEffectStr = scoreEffectStr.stringByAppendingFormat("+%i", GameConfig.scoreFish4)
            
        default:
            scoreEffectStr = scoreEffectStr.stringByAppendingFormat("+%i", GameConfig.scoreFish1)
            
        }
        
        var fish = self.childNodeWithName("fish") as SKSpriteNode?
        
        var labScoreEffect = SKLabelNode(text: scoreEffectStr)
        labScoreEffect.fontColor = UIColor.yellowColor()
        labScoreEffect.position = CGPoint.zeroPoint
        labScoreEffect.fontName = GameConfig.globalFontName01
        self.addChild(labScoreEffect)
        labScoreEffect.runAction(SKAction.moveBy(CGVectorMake(0, 20), duration: 0.5), completion: {
            labScoreEffect.removeFromParent()
        })
        
        super.cump()
    }
    
}
