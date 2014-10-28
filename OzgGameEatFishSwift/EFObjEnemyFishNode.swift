
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
        
        var animName: String?
        
        switch self.m_type! {
        case EnemyFishType.Fish2:
            self.m_textureAtlas = SKTextureAtlas(named: "Fish2")
            animName = "Fish2_"
            
        case EnemyFishType.Fish3:
            self.m_textureAtlas = SKTextureAtlas(named: "Fish3")
            animName = "Fish3_"
            
        case EnemyFishType.Fish4:
            self.m_textureAtlas = SKTextureAtlas(named: "Fish4")
            animName = "Fish4_"
            
        case EnemyFishType.Fish5:
            self.m_textureAtlas = SKTextureAtlas(named: "Fish5")
            animName = "Fish5_"
            
        case EnemyFishType.Fish6:
            self.m_textureAtlas = SKTextureAtlas(named: "Fish6")
            animName = "Fish6_"
            
        default:
            self.m_textureAtlas = SKTextureAtlas(named: "Fish1")
            animName = "Fish1_"
            
        }
        
        var frame = (self.m_textureAtlas?.textureNames[0] as? String)!
        var fish = SKSpriteNode(texture: (self.m_textureAtlas?.textureNamed(frame))!)
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
                
        self.playAnim(animName!)
    }
    
    deinit {
        println("EFObjEnemyFishNode释放")
    }
        
}
