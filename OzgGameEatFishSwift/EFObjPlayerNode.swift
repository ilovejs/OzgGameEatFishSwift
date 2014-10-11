
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
        self.addChild(fish)
        
        var center = SKSpriteNode()
        center.size = CGSizeMake(16, 16)
        center.name = "center"
        self.addChild(center)
        
        self.changeStatus(self.m_status!)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
        println("EFObjPlayerNode释放")
    }
    
    func changeStatus(status: Status) {
        self.m_status = status
        
        var water = self.childNodeWithName("water") as SKSpriteNode?
        var center = self.childNodeWithName("center") as SKSpriteNode?
        
        switch self.m_status! {
        
        case Status.Normal:
            self.m_animSpriteList = EFObjFishData.playerMFish()
            
            water?.setScale(10.0)
            
            center?.position = CGPointMake(56, 40)
            center?.size = CGSizeMake(56, 56)
            
        case Status.Big:
            self.m_animSpriteList = EFObjFishData.playerBFish()
            
            water?.setScale(15.0)
            
            center?.position = CGPointMake(120, 96)
            center?.size = CGSizeMake(96, 96)
            
        default:
            self.m_animSpriteList = EFObjFishData.playerFish()
            
            water?.setScale(5.0)
            
            center?.position = CGPointMake(28, 21)
            center?.size = CGSizeMake(16, 16)
            
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
