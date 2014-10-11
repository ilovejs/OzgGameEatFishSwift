
import Foundation
import SpriteKit

class EFObjJellyfishNode: EFObjBaseEnemyFishNode {
    
    override init() {
        super.init()
        
        self.m_animSpriteList = EFObjFishData.jellyFish()
        
        var fishTex = NSBundle.mainBundle().pathForResource((self.m_animSpriteList?[0].stringByDeletingPathExtension)!, ofType: self.m_animSpriteList?[0].pathExtension)!
        var fish = SKSpriteNode(texture: OzgSKTextureManager.getInstance!.get(fishTex))
        fish.position = CGPoint.zeroPoint
        fish.name = "fish"
        self.addChild(fish)
        
        var center = SKSpriteNode()
        center.size = CGSizeMake(56, 64)
        center.name = "center"
        self.addChild(center)
        
        self.playAnim()
    }
    
    deinit {
        println("EFObjJellyfishNode释放")
    }
    
}
