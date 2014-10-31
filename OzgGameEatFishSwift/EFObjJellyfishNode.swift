
import Foundation
import SpriteKit

class EFObjJellyfishNode: EFObjBaseEnemyFishNode {
    
    override init() {
        super.init()
        
        self.m_animFrames = EFObjFishData.jellyFish()
        
        var fish = SKSpriteNode(imageNamed: (self.m_animFrames?[0])!)
        fish.position = CGPoint.zeroPoint
        fish.name = "fish"
        fish.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(67, 94))
        fish.physicsBody?.dynamic = true
        fish.physicsBody?.allowsRotation = false
        fish.physicsBody?.friction = 0
        fish.physicsBody?.restitution = 1
        fish.physicsBody?.linearDamping = 0
        fish.physicsBody?.collisionBitMask = 0
        fish.physicsBody?.contactTestBitMask = 2
        fish.physicsBody?.categoryBitMask = 1        
        self.addChild(fish)
        
        self.playAnim()
    }
    
    deinit {
        println("EFObjJellyfishNode释放")
    }
    
}
