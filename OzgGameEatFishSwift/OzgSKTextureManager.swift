
import Foundation
import SpriteKit

class OzgSKTextureManager: NSObject {
    
    var m_textureObjects: Dictionary<String, SKTexture>?
    
    override init() {
        super.init()
        
        if self.m_textureObjects == nil {
            self.m_textureObjects = [:]
        }
    }
    
    deinit {
        self.m_textureObjects?.removeAll(keepCapacity: false)
        
    }
    
    func add(texName: String) {
        if self.m_textureObjects?[texName] != nil {
            //println("修改了Texture，Key为" + texName)
            self.m_textureObjects?.updateValue(SKTexture(image: UIImage(contentsOfFile: texName)!), forKey: texName)
        }
        else {
            //println("增加了Texture，Key为" + texName)
            self.m_textureObjects?[texName] = SKTexture(image: UIImage(contentsOfFile: texName)!)
        }
    }
    
    func get(texName: String) -> SKTexture? {
        if self.m_textureObjects?[texName] == nil {
            self.add(texName)            
        }
        //println("获取了Texture，Key为" + texName)
        return self.m_textureObjects?[texName]
    }
    
    func remove(texName: String) {
        
        if self.m_textureObjects?[texName] != nil {
            //println("删除了Texture，Key为" + texName)
            self.m_textureObjects?.removeValueForKey(texName)
        }
    }
    
    class var getInstance: OzgSKTextureManager? {
        struct Static {
            static let instance: OzgSKTextureManager? = OzgSKTextureManager()
        }
        return Static.instance
    }
    
}
