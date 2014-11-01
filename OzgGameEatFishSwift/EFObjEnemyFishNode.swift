
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
    
    var m_moveTime: Float?
    var m_moveStartPoint: CGPoint?
    var m_moveEndPoint: CGPoint?
    var m_moveTimeElapsed: Float?
    
    convenience init(type: EnemyFishType) {
        self.init()
        
        self.m_type = type
        self.m_moveTimeElapsed = 0
        
        switch self.m_type! {
        case EnemyFishType.Fish2:
            self.m_animFrames = EFObjFishData.fish2()
            
        case EnemyFishType.Fish3:
            self.m_animFrames = EFObjFishData.fish3()
            
        case EnemyFishType.Fish4:
            self.m_animFrames = EFObjFishData.fish4()
            
        case EnemyFishType.Fish5:
            self.m_animFrames = EFObjFishData.fish5()
            
        case EnemyFishType.Fish6:
            self.m_animFrames = EFObjFishData.fish6()
            
        default:
            self.m_animFrames = EFObjFishData.fish1()
            
        }
        
        var fish = SKSpriteNode(imageNamed: (self.m_animFrames?[0])!)
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
    
    //麻痹
    override func paralysis() {
        
        if self.m_isMoving == false {
            return
        }
        
        self.m_isMoving = false
        self.removeAllActions()
        
        var fish = self.childNodeWithName("fish") as SKSpriteNode?
        fish?.removeAllActions()
        
        var act1 = SKAction.moveBy(CGVectorMake(-3, 0), duration: 0.01)
        var act2 = SKAction.moveBy(CGVectorMake(6, 0), duration: 0.02)
        var act3 = act2.reversedAction()
        var act4 = SKAction.moveBy(CGVectorMake(3, 0), duration: 0.01)
        
        //麻痹5秒后恢复正常
        self.runAction(SKAction.sequence([ act1, act2, act3, act4, SKAction.waitForDuration(5) ]), completion: {
            self.playAnim()
            self.m_isMoving = true
            
            self.runAction(SKAction.moveTo(self.m_moveEndPoint!, duration: NSTimeInterval(self.m_moveTime! - self.m_moveTimeElapsed!)), completion: {
                self.removeFromParent()
            })
        })
    }
    
}
