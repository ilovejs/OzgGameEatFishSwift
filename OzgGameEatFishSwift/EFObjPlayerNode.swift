
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
        
        self.playAnim()
    }
    
}
