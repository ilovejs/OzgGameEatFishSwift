
import Foundation
import SpriteKit

class EFGameScene: EFBaseScene {
    
    var m_playerLife: Int?
    var m_stageNum: Int? //关卡
    var m_score: Int? //分数
    
    var m_eatFish: Int? //吃了鱼的分数，用来判断变大的，player死了会清0
    var m_eatFishTotal: Int? //吃了鱼的总数
    var m_eatFishTotalType1And2: Int? //吃了Type1和2的鱼的总数
    var m_eatFishTotalType3: Int? //吃了Type3的鱼的总数
    var m_eatFishTotalType4: Int? //吃了Type4的鱼的总数
    
    var m_bg: String?
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        self.m_playerLife = GameConfig.players
        self.m_stageNum = 1
        self.m_score = 0
        
        self.m_eatFish = 0
        self.m_eatFishTotal = 0
        self.m_eatFishTotalType1And2 = 0
        self.m_eatFishTotalType3 = 0
        self.m_eatFishTotalType4 = 0
        
        var bgList = [ "bg1.png", "bg2.png", "bg3.png" ]
        var bgIndex = Int(arc4random_uniform(UInt32(bgList.count)))
        
        self.m_bg = bgList[bgIndex]
        
        //背景
        var bg = SKSpriteNode(texture: OzgSKTextureManager.getInstance!.get(NSBundle.mainBundle().pathForResource(self.m_bg!.stringByDeletingPathExtension, ofType: self.m_bg!.pathExtension)!))
        bg.position = CGPointMake(self.size.width / 2, self.size.height / 2)
        bg.name = "bg"
        self.addChild(bg)
        
        //水泡
        self.showBlister("blister_left", position: CGPointMake(self.size.width / 2 - 300, 120))
        self.showBlister("blister_right", position: CGPointMake(self.size.width / 2 + 300, 120))
        
        //所有的鱼元素都在这个Node
        var fishNode = SKNode()
        fishNode.position = CGPoint.zeroPoint
        fishNode.name = "fish_node"
        self.addChild(fishNode)
                
        //test anim
//        var player = EFObjPlayerNode()
//        player.position = CGPointMake(self.size.width / 2, self.size.height / 2)
//        fishNode.addChild(player)
//        player.invincible()
//        
//        player.orientationRight() //test
//        player.cump(EFObjEnemyFishNode.EnemyFishType.Fish1) //test
//        
//        var jellyFish = EFObjJellyfishNode()
//        jellyFish.position = CGPointMake(self.size.width / 2, 450)
//        fishNode.addChild(jellyFish)
//        
//        var enemyFish1 = EFObjEnemyFishNode(type: EFObjEnemyFishNode.EnemyFishType.Fish2)
//        enemyFish1.position = CGPointMake(200, 200)
//        fishNode.addChild(enemyFish1)
        
        //test anim end
        
        var stageNumLab = SKLabelNode(text: NSLocalizedString("GameScene_LabStage", tableName: nil, comment: "Stage").stringByAppendingFormat("%i", self.m_stageNum!))
        stageNumLab.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        stageNumLab.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        stageNumLab.position = CGPointMake(750, 600)
        stageNumLab.fontName = GameConfig.globalFontName01
        stageNumLab.fontSize = 28
        self.addChild(stageNumLab)
        
        var scoreLab = SKLabelNode(text: NSLocalizedString("GameScene_LabScore", tableName: nil, comment: "Score").stringByAppendingFormat("%i", self.m_score!))
        scoreLab.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        scoreLab.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        scoreLab.position = CGPointMake(750, 560)
        scoreLab.fontSize = 28
        scoreLab.fontName = GameConfig.globalFontName01
        self.addChild(scoreLab)
        
        var btnPause = OzgSKButtonNode(normalImg: "pause_up.png", downImg: "pause_dw.png", disableImg: "pause_dw.png", title: nil)
        btnPause.position = CGPointMake(self.size.width - 125, self.size.height - 125)
        btnPause.name = "btn_pause"
        btnPause.setTouchedCallBack(self.onButton)
        self.addChild(btnPause)
        
        //左上角的部分
        
        var progressBgTex = NSBundle.mainBundle().pathForResource("Fishtales/progress", ofType: "png")!
        var progressBg = SKSpriteNode(texture: OzgSKTextureManager.getInstance!.get(progressBgTex))
        progressBg.position = CGPointMake(80, 610)
        self.addChild(progressBg)
        
        //暂时使用SKSpriteNode来替代进度条
        var progressTex = NSBundle.mainBundle().pathForResource("progressk", ofType: "png")!
        var progress = SKSpriteNode(texture: OzgSKTextureManager.getInstance!.get(progressTex))
        progress.position = CGPointMake(80, 594)
        progress.position = CGPointMake(progress.position.x - (progress.size.width / 2), progress.position.y)
        progress.name = "progress"
        progress.anchorPoint = CGPointMake(0, 0.5)
        progress.xScale = 0.0
        self.addChild(progress)
        
        var fishLifeTex = NSBundle.mainBundle().pathForResource("Fishtales/fishlife", ofType: "png")!
        var fishLife = SKSpriteNode(texture: OzgSKTextureManager.getInstance!.get(fishLifeTex))
        fishLife.position = CGPointMake(70, 550)
        self.addChild(fishLife)
        
        var fishLifeLab = SKLabelNode(text: String(self.m_playerLife!))
        fishLifeLab.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        fishLifeLab.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        fishLifeLab.position = CGPointMake(90, 540)
        fishLifeLab.fontSize = 28
        fishLifeLab.fontName = GameConfig.globalFontName01
        self.addChild(fishLifeLab)
        
    }
    
    override func willMoveFromView(view: SKView) {
        
    }
    
    override func update(currentTime: NSTimeInterval) {
        
        var fishNode = self.childNodeWithName("fish_node")
        if fishNode == nil {
            return
        }
        
        //水母
        if OzgSwiftUtility.randomRange(0, maxValue: 1) <= GameConfig.enemyJellyfish {
            
            var enemyFishNode = EFObjJellyfishNode()
            var minVal = enemyFishNode.fishSize().width / 2
            var maxVal = self.size.width - (enemyFishNode.fishSize().width / 2)
            
            var srcX:Float = Float(maxVal - minVal)
            srcX = Float(minVal) + (srcX * OzgSwiftUtility.randomRange(0, maxValue: 1))
            
            enemyFishNode.position = CGPointMake(CGFloat(srcX), -enemyFishNode.fishSize().width / 2)
            fishNode?.addChild(enemyFishNode)
            
            var moveTime: Float = 15.0 - 10.0
            moveTime = 10.0 + (moveTime * OzgSwiftUtility.randomRange(0, maxValue: 1))
            enemyFishNode.runAction(SKAction.sequence([ SKAction.moveTo(CGPointMake(CGFloat(srcX), self.size.height + (enemyFishNode.fishSize().height / 2)), duration: NSTimeInterval(moveTime)) ]), completion: {
                
                enemyFishNode.removeFromParent()
                
            })
            
        }
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        
        //var fishNode = self.childNodeWithName("fish_node")
        
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        
    }
    
    //水泡粒子系统
    func showBlister(name: String, position: CGPoint) {
        var blisterLeft = SKEmitterNode()
        blisterLeft.particleTexture = OzgSKTextureManager.getInstance!.get(NSBundle.mainBundle().pathForResource("blister", ofType: "png")!)
        blisterLeft.particleBirthRate = 1
        blisterLeft.particleLifetime = 8
        blisterLeft.particlePositionRange = CGVectorMake(75, 0)
        blisterLeft.particleScale = 0.25
        blisterLeft.particleScaleRange = 0.05
        blisterLeft.particleBlendMode = SKBlendMode.Alpha
        blisterLeft.particleColorBlendFactor = 1 //调整颜色需要设置这个
        
        blisterLeft.particleColor = SKColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.5)
        blisterLeft.particleAlphaRange = 0.25
        
        blisterLeft.emissionAngle = CGFloat(M_PI) / 180.0 * 90.0
        blisterLeft.yAcceleration = 100
        
        blisterLeft.position = position
        blisterLeft.name = name
        self.addChild(blisterLeft)
    }
    
    //暂停
    func scenePause() {
        
    }
    
    func onButton(sender: AnyObject!) {
        
        var btn: OzgSKButtonNode = sender as OzgSKButtonNode
        
        if btn.name! == "btn_pause" {
            
        }
    }
    
}
