
import Foundation
import SpriteKit

class EFObjBaseFishNode: SKNode {
    
    enum Orientation {
        case Left
        case Right
    }
    
    var m_orientation: Orientation? //朝向
    var m_isMoving: Bool?
    
    var m_animSpriteList: Array<String>?
    
    override init() {
        super.init()
        
        self.m_isMoving = true
        self.m_orientation = Orientation.Left
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        println("EFObjBaseFishNode释放")
        
    }
    
    func centerPointRect() -> CGRect {
        var center = self.childNodeWithName("center") as SKSpriteNode?
        if center == nil {
            return CGRect.zeroRect
        }
        
        var point = center?.position
        point = self.convertPoint(point!, toNode: (self.parent?.parent)!)
        return CGRectMake((point?.x)!, (point?.y)!, (center?.size.width)!, (center?.size.height)!)
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
        
        var cumpList = [ "cump/cump1.png", "cump/cump2.png", "cump/cump3.png", "cump/cump4.png", "cump/cump5.png" ]
        var cumpIndex = Int(arc4random_uniform(UInt32(cumpList.count)))
        
        var chum = SKSpriteNode(texture: OzgSKTextureManager.getInstance!.get(NSBundle.mainBundle().pathForResource(cumpList[cumpIndex].stringByDeletingPathExtension, ofType: cumpList[cumpIndex].pathExtension)!))
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
        self.runAction(SKAction.sequence([ act1, act2, act3, act4 ]), completion: {
            self.playAnim()
            self.m_isMoving = true
        })
    }
    
    func playAnim() {
        var fish = self.childNodeWithName("fish") as SKSpriteNode?
        if fish != nil && self.m_animSpriteList != nil {
            
            var frames: Array<SKTexture> = []
            
            for var i = 0; i < self.m_animSpriteList?.count; i++ {
                var texName = NSBundle.mainBundle().pathForResource((self.m_animSpriteList?[i].stringByDeletingPathExtension)!, ofType: self.m_animSpriteList?[i].pathExtension)!
                frames.append((OzgSKTextureManager.getInstance!.get(texName))!)
            }
            
            var anim: SKAction = SKAction.repeatActionForever(SKAction.animateWithTextures(frames, timePerFrame: 0.1))
                        
            fish?.removeAllActions()
            fish?.runAction(anim)
            
        }
    }
    
}
