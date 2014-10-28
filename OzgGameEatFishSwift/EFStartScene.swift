
import Foundation
import SpriteKit

class EFStartScene: EFBaseScene {
    
    deinit {
        
        println("EFStartScene释放")
    }
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        var bg = SKSpriteNode(imageNamed: "bg1")
        bg.position = CGPointMake(self.size.width / 2, self.size.height / 2)
        self.addChild(bg)
        
        var title = SKSpriteNode(imageNamed: "scene_start_title")
        title.position = CGPointMake(self.size.width / 2, 510)
        title.name = "title"
        self.addChild(title)
        
        var btnStart = OzgSKButtonNode(normalImg: "btn1_up", downImg: "btn1_dw", disableImg: "btn1_dw", title: NSLocalizedString("StartScene_BtnStart", tableName: nil, comment: "Start"))
        btnStart.position = CGPointMake(self.size.width / 2, 230)
        btnStart.name = "btn_start"
        btnStart.setTouchedCallBack(self.onButton)
        self.addChild(btnStart)
        
        var btnHelp = OzgSKButtonNode(normalImg: "btn1_up", downImg: "btn1_dw", disableImg: "btn1_dw", title: NSLocalizedString("StartScene_BtnHelp", tableName: nil, comment: "Help"))
        btnHelp.position = CGPointMake(self.size.width / 2, 130)
        btnHelp.name = "btn_help"
        btnHelp.setTouchedCallBack(self.onButton)
        self.addChild(btnHelp)
                
    }
    
    override func willMoveFromView(view: SKView) {
        println("EFStartScene::willMoveFromView")
        
        while self.children.last != nil {
            
            (self.children.last as SKNode).removeFromParent()
            
        }
        
    }
    
    func onButton(sender: AnyObject!) {
        
        var btn: OzgSKButtonNode = sender as OzgSKButtonNode
        
        switch btn.name! {
            
        case "btn_help":
            //帮助界面
            
            self.playEffectAudio("audios_btn.wav")
            
            self.childNodeWithName("title")?.hidden = true
            self.childNodeWithName("btn_start")?.hidden = true
            self.childNodeWithName("btn_help")?.hidden = true
            
            var btnBack = OzgSKButtonNode(normalImg: "btn1_up", downImg: "btn1_dw", disableImg: "btn1_dw", title: NSLocalizedString("StartScene_HelpBtnBack", tableName: nil, comment: "Back"))
            btnBack.position = CGPointMake(830, 60)
            btnBack.name = "btn_back"
            btnBack.setTouchedCallBack(self.onButton)
            self.addChild(btnBack)
            
            var howtoplay = SKSpriteNode(imageNamed: "howtoplay")
            howtoplay.position = CGPointMake(self.size.width / 2, 350)
            howtoplay.name = "howtoplay"
            self.addChild(howtoplay)
            
            var howtoplayTitle = SKLabelNode(text: NSLocalizedString("StartScene_HelpTitle", tableName: nil, comment: "Help:"))
            howtoplayTitle.position = CGPointMake(0, 200)
            howtoplayTitle.fontName = GameConfig.globalFontName02
            howtoplayTitle.fontColor = UIColor.yellowColor()
            howtoplay.addChild(howtoplayTitle)
            
            var howtoplayLab1 = SKLabelNode(text: NSLocalizedString("StartScene_Help1", tableName: nil, comment: "Help1"))
            howtoplayLab1.position = CGPointMake(0, 55)
            howtoplayLab1.fontSize = 24
            howtoplayLab1.fontName = GameConfig.globalFontName01
            howtoplay.addChild(howtoplayLab1)
            
            var howtoplayLab2 = SKLabelNode(text: NSLocalizedString("StartScene_Help2", tableName: nil, comment: "Help2"))
            howtoplayLab2.position = CGPointMake(0, -82)
            howtoplayLab2.fontSize = 24
            howtoplayLab2.fontName = GameConfig.globalFontName01
            howtoplay.addChild(howtoplayLab2)
            
            var howtoplayLab3 = SKLabelNode(text: NSLocalizedString("StartScene_Help3", tableName: nil, comment: "Help3"))
            howtoplayLab3.position = CGPointMake(0, -224)
            howtoplayLab3.fontSize = 24
            howtoplayLab3.fontName = GameConfig.globalFontName01
            howtoplay.addChild(howtoplayLab3)
            
        case "btn_back":
            //取消帮助界面
            
            self.playEffectAudio("audios_btn.wav")
            
            self.childNodeWithName("title")?.hidden = false
            self.childNodeWithName("btn_start")?.hidden = false
            self.childNodeWithName("btn_help")?.hidden = false
            self.childNodeWithName("btn_back")?.removeFromParent()
            self.childNodeWithName("howtoplay")?.removeFromParent()
                        
        default:
            //进入游戏
            
            let scene = EFGameScene(fileNamed: "EFGameScene")
            var t = SKTransition.fadeWithDuration(GameConfig.transitionTime)
            scene.scaleMode = SKSceneScaleMode.AspectFit
            self.view?.presentScene(scene, transition: t)
        }
        
    }
    
}
