
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
        
        switch self.m_type! {
        case EnemyFishType.Fish2:
            fish.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(16, 16))
            
        case EnemyFishType.Fish3:
            fish.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(28, 28))
            
        case EnemyFishType.Fish4:
            fish.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(42, 42))
            
        case EnemyFishType.Fish5:
            fish.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(148, 108))
            
        case EnemyFishType.Fish6:
            fish.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(148, 108))
            
        default:
            fish.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(16, 16))
            
        }
        
        fish.physicsBody?.dynamic = true
        fish.physicsBody?.allowsRotation = false
        fish.physicsBody?.friction = 0
        fish.physicsBody?.restitution = 1
        fish.physicsBody?.linearDamping = 0
        fish.physicsBody?.collisionBitMask = 0
        fish.physicsBody?.contactTestBitMask = 3
        fish.physicsBody?.categoryBitMask = 1
        self.addChild(fish)
                
        self.playAnim()
    }
    
    deinit {
        println("EFObjEnemyFishNode释放")
    }
    
}
