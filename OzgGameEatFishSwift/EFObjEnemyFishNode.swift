
import Foundation
import SpriteKit

class EFObjEnemyFishNode: EFObjBaseEnemyFishNode {

    enum EnemyFishType {
        case Fish1
        case Fish2
        case Fish3
        case Fish4
        case Fish5
        case Fish6
    }

    var m_type: EnemyFishType?
    
    convenience init(type: EnemyFishType) {
        self.init()
        
        self.m_type = type
        
        switch self.m_type! {
        case EnemyFishType.Fish2:
            self.m_animSpriteList = EFObjFishData.fish2()
            
        case EnemyFishType.Fish3:
            self.m_animSpriteList = EFObjFishData.fish3()
            
        case EnemyFishType.Fish4:
            self.m_animSpriteList = EFObjFishData.fish4()
            
        case EnemyFishType.Fish5:
            self.m_animSpriteList = EFObjFishData.fish5()
            
        case EnemyFishType.Fish6:
            self.m_animSpriteList = EFObjFishData.fish6()
            
        default:
            self.m_animSpriteList = EFObjFishData.fish1()
            
        }
        
        var fishTex = NSBundle.mainBundle().pathForResource((self.m_animSpriteList?[0].stringByDeletingPathExtension)!, ofType: self.m_animSpriteList?[0].pathExtension)!
        var fish = SKSpriteNode(texture: OzgSKTextureManager.getInstance!.get(fishTex))
        fish.position = CGPoint.zeroPoint
        fish.name = "fish"
        self.addChild(fish)
        
        var center = SKSpriteNode()
        center.name = "center"
        switch self.m_type! {
        case EnemyFishType.Fish2:
            center.position = CGPointMake(fish.size.width / 2, 12)
            center.size = CGSizeMake(16, 16)
            
        case EnemyFishType.Fish3:
            center.position = CGPointMake(fish.size.width / 2, 30)
            center.size = CGSizeMake(24, 24)
            
        case EnemyFishType.Fish4:
            center.position = CGPointMake(fish.size.width / 2, 50)
            center.size = CGSizeMake(40, 40)
            
        case EnemyFishType.Fish5:
            center.position = CGPointMake(fish.size.width / 2, 105)
            center.size = CGSizeMake(128, 96)
            
        case EnemyFishType.Fish6:
            center.position = CGPointMake(fish.size.width / 2, 105)
            center.size = CGSizeMake(128, 96)
            
        default:
            center.position = CGPointMake(fish.size.width / 2, 12)
            center.size = CGSizeMake(16, 16)
            
        }
        self.addChild(center)
        
        self.playAnim()
    }
    
    deinit {
        println("EFObjEnemyFishNode释放")
    }
    
}
