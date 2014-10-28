
import Foundation
import SpriteKit

class EFObjBaseFishNode: SKNode {
    
    enum Orientation {
        case Left
        case Right
    }
    
    var m_orientation: Orientation? //朝向
    var m_isMoving: Bool?
    
    var m_textureAtlas: SKTextureAtlas?
    var m_animName: String?
    
    override init() {
        super.init()
        
        self.m_isMoving = true
        self.m_orientation = Orientation.Left
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        println("EFObjBaseFishNode释放")
        
    }

    func fishSize() -> CGSize {
        var fish = self.childNodeWithName("fish") as SKSpriteNode?
        return (fish?.size)!
    }
    
    //朝向左边
    func orientationLeft() {
        self.m_orientation = Orientation.Left
        
        //正转
        var fish = self.childNodeWithName("fish") as SKSpriteNode?
        fish?.xScale = fabs((fish?.xScale)!) * 1
    }
    
    //朝向右边
    func orientationRight() {
        self.m_orientation = Orientation.Right
        
        //反转
        var fish = self.childNodeWithName("fish") as SKSpriteNode?
        fish?.xScale = fabs((fish?.xScale)!) * -1
    }
    
    //吃了对方
    func cump() {
        var cump = self.childNodeWithName("cump") as SKSpriteNode?
        if cump != nil {
            cump?.removeAllActions()
            cump?.removeFromParent()
        }
        
        var fish = self.childNodeWithName("fish") as SKSpriteNode?
        
        var cumpList = [ "cump1", "cump2", "cump3", "cump4", "cump5" ]
        var cumpIndex = Int(arc4random_uniform(UInt32(cumpList.count)))
        
        var chum = SKSpriteNode(imageNamed: cumpList[cumpIndex])
        if self.m_orientation == Orientation.Left {
            
            chum.position = CGPointMake(-chum.size.width / 2, (fish?.size.height)! / 2)
        }
        else {
            
            chum.position = CGPointMake((fish?.size.width)! + (chum.size.width / 2), (fish?.size.height)! / 2)
        }
        
        chum.name = "chum"
        self.addChild(chum)
        
        chum.runAction(SKAction.waitForDuration(0.2), completion: {
            chum.removeFromParent()
        })
        
    }
    
    //麻痹
    func paralysis() {
        
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
        })
    }
    
    func playAnim() {
        self.playAnim(self.m_animName!)
    }
    
    func playAnim(animName: String) {
        self.m_animName = animName
        
        var fish = self.childNodeWithName("fish") as SKSpriteNode?
        if fish != nil && self.m_textureAtlas != nil {
            
            var frames: Array<SKTexture> = []
            
            for var i = 0; i < (self.m_textureAtlas?.textureNames.count)!; i++ {
                var frame = self.m_animName!.stringByAppendingFormat("%i", i + 1)
                frames.append((self.m_textureAtlas?.textureNamed(frame))!)
            }
            
            //这个动画执行了之后，第二帧以后会跑到最上面，不知道是什么问题
            
            var anim: SKAction = SKAction.repeatActionForever(SKAction.animateWithTextures(frames, timePerFrame: 0.1))
                        
            fish?.removeAllActions()
            fish?.runAction(anim)
            
        }
    }
    
    override func removeFromParent() {
        self.removeAllActions()
        self.removeAllChildren()
        super.removeFromParent()
    }
    
}
