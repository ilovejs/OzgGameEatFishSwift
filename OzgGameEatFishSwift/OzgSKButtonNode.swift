
import Foundation
import SpriteKit

class OzgSKButtonNode: SKSpriteNode {
    
    var m_normalTex: SKTexture?
    var m_downTex: SKTexture?
    var m_disableTex: SKTexture?
    var m_enable: Bool?
    var m_touchedCallBack: (AnyObject! -> Void)?
    
    init(normalImg: String?, downImg: String?, disableImg: String?, title: String?) {
        
        self.m_normalTex = SKTexture(imageNamed: normalImg!)
        self.m_downTex = SKTexture(imageNamed: downImg!)
        self.m_disableTex = SKTexture(imageNamed: disableImg!)
        
        self.m_enable = true
        
        super.init(texture: self.m_normalTex!, color: UIColor(white: 1, alpha: 0), size: self.m_normalTex!.size())
        self.userInteractionEnabled = true
        
        if title != nil {
            var titleLab = SKLabelNode(text: title!)
            titleLab.position = CGPointMake(titleLab.position.x, titleLab.position.y - 6.0)
            titleLab.name = "title"
            titleLab.fontName = "Arial"
            titleLab.fontSize = 24
            self.addChild(titleLab)
        }
    }
    
    deinit {
        
        println("OzgSKButtonNode释放")
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        if self.m_enable! == false {
            return
        }
        
        self.texture = self.m_downTex
        
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        if self.m_enable! == false {
            return
        }
        
        self.texture = self.m_normalTex
        
        self.m_touchedCallBack?(self)
    }
    
    func setEnable(enable: Bool) {
        self.m_enable = enable
        
        if self.m_enable! == true {
            self.texture = self.m_normalTex
        }
        else {
            self.texture = self.m_disableTex
        }
    }
    
    func setTitleText(title: String) {
        var titleLab: SKLabelNode? = self.childNodeWithName("title") as SKLabelNode?
        titleLab?.text = title
    }
    
    func setTitleFontName(fontName: String) {
        var titleLab: SKLabelNode? = self.childNodeWithName("title") as SKLabelNode?
        titleLab?.fontName = fontName
    }
    
    func setTitleFontSize(fontSize: CGFloat) {
        var titleLab: SKLabelNode? = self.childNodeWithName("title") as SKLabelNode?
        titleLab?.fontSize = fontSize
    }
    
    func setTitleFontColor(fontColor: UIColor) {
        var titleLab: SKLabelNode? = self.childNodeWithName("title") as SKLabelNode?
        titleLab?.fontColor = fontColor
    }
    
    func setTouchedCallBack(touchedCallBack: (AnyObject! -> Void)) {
        self.m_touchedCallBack = touchedCallBack
        
    }
    
}
