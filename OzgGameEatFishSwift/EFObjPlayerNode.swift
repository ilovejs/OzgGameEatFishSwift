
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
        
        var texName = NSBundle.mainBundle().pathForResource("Fishall/" + (self.m_animSpriteList?[0].stringByDeletingPathExtension)!, ofType: self.m_animSpriteList?[0].pathExtension)!
        var fish = SKSpriteNode(texture: OzgSKTextureManager.getInstance!.get(texName))
        fish.position = CGPoint.zeroPoint
        fish.name = "fish"
        self.addChild(fish)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
        println("EFObjPlayerNode释放")
    }
    
}
