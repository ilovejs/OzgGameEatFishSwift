
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
        
        self.m_isMoving = false
        self.m_orientation = Orientation.Left
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        
    }
    
    func centerRect() -> CGRect {
        return CGRect.zeroRect
    }
    
    //朝向左边
    func orientationLeft() {
    
    }
    
    //朝向右边
    func orientationRight() {
        
    }
    
    //吃了对方
    func cump() {
    
    }
    
    //麻痹
    func paralysis() {
    
    }
    
    func playAnim() {
        var fish = self.childNodeWithName("fish") as SKSpriteNode?
        if fish != nil && self.m_animSpriteList != nil {
            
            var frames: Array<SKTexture> = []
            
            for var i = 0; i < self.m_animSpriteList?.count; i++ {
                var texName = NSBundle.mainBundle().pathForResource("Fishall/" + (self.m_animSpriteList?[i].stringByDeletingPathExtension)!, ofType: self.m_animSpriteList?[i].pathExtension)!
                frames.append((OzgSKTextureManager.getInstance!.get(texName))!)
            }
            
            var anim: SKAction = SKAction.repeatActionForever(SKAction.animateWithTextures(frames, timePerFrame: 0.1))
                        
            fish?.removeAllActions()
            fish?.runAction(anim)
            
        }
    }
    
}
