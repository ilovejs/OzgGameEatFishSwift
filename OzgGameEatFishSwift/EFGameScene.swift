
import Foundation
import SpriteKit

class EFGameScene: EFBaseScene, SKPhysicsContactDelegate, UIAlertViewDelegate {
    
    var m_playerLife: Int?
    var m_stageNum: Int? //关卡
    var m_score: Int? //分数
    
    var m_eatFish: Int? //吃了鱼的分数，用来判断变大的，player死了会清0
    var m_eatFishTotal: Int? //吃了鱼的总数
    var m_eatFishTotalType1And2: Int? //吃了Type1和2的鱼的总数
    var m_eatFishTotalType3: Int? //吃了Type3的鱼的总数
    var m_eatFishTotalType4: Int? //吃了Type4的鱼的总数
    
    var m_isPauseUpdate: Bool? //为true的时候跳过update方法
    
    var m_bg: String?
    
    var m_updateTime: Float?
    var m_updatePrevTime: Float?
    
    deinit {
        
        println("EFGameScene释放")
    }
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsWorld.contactDelegate = self
        
        self.m_playerLife = GameConfig.players
        self.m_stageNum = 1
        self.m_score = 0
        
        self.m_eatFish = 0
        self.m_eatFishTotal = 0
        self.m_eatFishTotalType1And2 = 0
        self.m_eatFishTotalType3 = 0
        self.m_eatFishTotalType4 = 0
        
        var bgList = [ "bg1", "bg2", "bg3" ]
        var bgIndex = Int(arc4random_uniform(UInt32(bgList.count)))
        
        self.m_bg = bgList[bgIndex]
        
        //背景
        var bg = SKSpriteNode(imageNamed: self.m_bg!)
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
        
        //player
        self.m_isPauseUpdate = true
        var player = EFObjPlayerNode()
        player.name = "player"
        player.position = CGPointMake(self.size.width / 2, 800)
        fishNode.addChild(player)
        player.invincible()
        
        //test anim
        
//        var jellyFish = EFObjJellyfishNode()
//        jellyFish.position = CGPointMake(self.size.width / 2, 450)
//        jellyFish.name = "jellyFish"
//        fishNode.addChild(jellyFish)

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
        stageNumLab.name = "stageNumLab"
        self.addChild(stageNumLab)
        
        var scoreLab = SKLabelNode(text: NSLocalizedString("GameScene_LabScore", tableName: nil, comment: "Score").stringByAppendingFormat("%i", self.m_score!))
        scoreLab.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        scoreLab.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        scoreLab.position = CGPointMake(750, 560)
        scoreLab.fontSize = 28
        scoreLab.fontName = GameConfig.globalFontName01
        scoreLab.name = "scoreLab"
        self.addChild(scoreLab)
        
        var btnPause = OzgSKButtonNode(normalImg: "pause_up", downImg: "pause_dw", disableImg: "pause_dw", title: nil)
        btnPause.position = CGPointMake(self.size.width - 125, self.size.height - 125)
        btnPause.name = "btn_pause"
        btnPause.setTouchedCallBack(self.onButton)
        self.addChild(btnPause)
        
        //左上角的部分
        
        var progressBg = SKSpriteNode(imageNamed: "progress")
        progressBg.position = CGPointMake(80, 610)
        self.addChild(progressBg)
        
        //暂时使用SKSpriteNode来替代进度条
        var progress = SKSpriteNode(imageNamed: "progressk")
        progress.position = CGPointMake(80, 594)
        progress.position = CGPointMake(progress.position.x - (progress.size.width / 2), progress.position.y)
        progress.name = "progress"
        progress.anchorPoint = CGPointMake(0, 0.5)
        progress.xScale = 0.0
        self.addChild(progress)
        
        var fishLife = SKSpriteNode(imageNamed: "fishlife")
        fishLife.position = CGPointMake(70, 550)
        self.addChild(fishLife)
        
        var fishLifeLab = SKLabelNode(text: String(self.m_playerLife!))
        fishLifeLab.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        fishLifeLab.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        fishLifeLab.position = CGPointMake(90, 540)
        fishLifeLab.fontSize = 28
        fishLifeLab.fontName = GameConfig.globalFontName01
        fishLifeLab.name = "fishLifeLab"
        self.addChild(fishLifeLab)
        
        self.enabledTouchEvent(false)
        
        self.runAction(SKAction.waitForDuration(GameConfig.transitionTime), completion: {
            self.gameStart()
        })
        
    }
    
    override func willMoveFromView(view: SKView) {
        println("EFGameScene::willMoveFromView")
        
        while self.children.last != nil {
            
            (self.children.last as SKNode).removeFromParent()
            
        }
        
    }
    
    override func update(currentTime: NSTimeInterval) {
        
        if self.m_updateTime == nil {
            self.m_updateTime = Float(currentTime)
            self.m_updatePrevTime = Float(currentTime)
        }
        else {
            self.m_updateTime = Float(currentTime) - self.m_updatePrevTime!
            self.m_updatePrevTime = Float(currentTime)
        }
        
        if self.m_isPauseUpdate! == true {
            return
        }
        
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

        //fish1
        if OzgSwiftUtility.randomRange(0, maxValue: 1) <= GameConfig.enemyFish1 {
            self.enemyFishEmergence(EFObjEnemyFishNode(type: EFObjEnemyFishNode.EnemyFishType.Fish1))
            
        }
        
        //fish2
        if OzgSwiftUtility.randomRange(0, maxValue: 1) <= GameConfig.enemyFish2 {
            self.enemyFishEmergence(EFObjEnemyFishNode(type: EFObjEnemyFishNode.EnemyFishType.Fish2))
            
        }

        //fish3
        if OzgSwiftUtility.randomRange(0, maxValue: 1) <= GameConfig.enemyFish3 {
            self.enemyFishEmergence(EFObjEnemyFishNode(type: EFObjEnemyFishNode.EnemyFishType.Fish3))
            
        }
        
        //fish4
        if OzgSwiftUtility.randomRange(0, maxValue: 1) <= GameConfig.enemyFish4 {
            self.enemyFishEmergence(EFObjEnemyFishNode(type: EFObjEnemyFishNode.EnemyFishType.Fish4))
            
        }
        
        //fish5
        if OzgSwiftUtility.randomRange(0, maxValue: 1) <= GameConfig.enemyFish5 {
            self.enemyFishEmergence(EFObjEnemyFishNode(type: EFObjEnemyFishNode.EnemyFishType.Fish5))
            
        }
        
        //fish6
        if OzgSwiftUtility.randomRange(0, maxValue: 1) <= GameConfig.enemyFish6 {
            self.enemyFishEmergence(EFObjEnemyFishNode(type: EFObjEnemyFishNode.EnemyFishType.Fish6))
            
        }
        
        //更新enemyfish的m_moveTimeElapsed
        for var i = 0; i < (fishNode?.children.count)!; i++ {
            var item: SKNode = (fishNode?.children[i])! as SKNode
            if item.isKindOfClass(EFObjEnemyFishNode) {
                
                if (item as EFObjEnemyFishNode).m_isMoving! == true {
                    (item as EFObjEnemyFishNode).m_moveTimeElapsed = (item as EFObjEnemyFishNode).m_moveTimeElapsed! + self.m_updateTime!
                }
            }
        }
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        
        var fishNode = self.childNodeWithName("fish_node")
        var player = fishNode?.childNodeWithName("player") as EFObjPlayerNode?
        if player != nil && ((player as EFObjPlayerNode?)?.m_isMoving)! == true {
            var touch: UITouch? = touches.anyObject() as UITouch?
            
            var beginPoint =  touch?.locationInNode(self)
            var endPoint = touch?.previousLocationInNode(self)
            var offset = CGPointMake((beginPoint?.x)! - (endPoint?.x)!, (beginPoint?.y)! - (endPoint?.y)!)
            var toPoint = CGPointMake((player?.position.x)! + offset.x, (player?.position.y)! + offset.y)
            
            var toX = (player?.position.x)!
            var toY = (player?.position.y)!
            
            if toPoint.x >= 0 && toPoint.x <= self.size.width {
                toX = toPoint.x
            }
            if toPoint.y >= 0 && toPoint.y <= self.size.height {
                toY = toPoint.y
            }
            player?.position = CGPointMake(toX, toY)
            
            if offset.x > 0 {
                player?.orientationRight() //向右移动则转向右边
            }
            else if (offset.x < 0) {
                player?.orientationLeft() //向左移动则转向左边
            }
            
        }
        
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        
    }
    
    func gameStart() {
        self.playEffectAudio("audios_fishstart.mp3")
        
        var fishNode = self.childNodeWithName("fish_node")
        var player = fishNode?.childNodeWithName("player") as EFObjPlayerNode?
        player?.runAction(SKAction.moveBy(CGVectorMake(0, -400), duration: 1.0), completion: {
            self.enabledTouchEvent(true)
            self.m_isPauseUpdate = false
            player?.m_isMoving = true
        })
        
    }
    
    //水泡粒子系统
    func showBlister(name: String, position: CGPoint) {
        var blisterLeft = SKEmitterNode()
        blisterLeft.particleTexture = SKTexture(imageNamed: "blister")
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
        
        if self.childNodeWithName("pause_node") != nil {
            return
        }
        
        var fishNode = self.childNodeWithName("fish_node")
        for var i = 0; i < (fishNode?.children.count)!; i++ {
            var item: SKNode = (fishNode?.children[i])! as SKNode
            item.paused = true
            
        }
        
        self.m_isPauseUpdate = true
        self.enabledTouchEvent(false)
        
        //暂停界面
        
        var pauseNode = SKNode()
        pauseNode.position = CGPoint.zeroPoint
        pauseNode.name = "pause_node"
        self.addChild(pauseNode)
        
        var pauseBg = SKSpriteNode(imageNamed: "pausebg")
        pauseBg.position = CGPointMake(self.size.width / 2, self.size.height / 2)
        pauseNode.addChild(pauseBg)
        
        var btnResume = OzgSKButtonNode(normalImg: "btn1_up", downImg: "btn1_dw", disableImg: "btn1_dw", title: NSLocalizedString("GameScene_PauseBtnResume", tableName: nil, comment: "resume"))
        btnResume.position = CGPointMake(180, 470)
        btnResume.name = "btn_resume"
        btnResume.setTouchedCallBack(self.onButton)
        pauseNode.addChild(btnResume)
        
        var btnSound = OzgSKButtonNode(normalImg: "btn1_up", downImg: "btn1_dw", disableImg: "btn1_dw", title: "Off")
        btnSound.position = CGPointMake(180, 364)
        btnSound.name = "btn_sound"
        btnSound.setTouchedCallBack(self.onButton)
        if NSUserDefaults.standardUserDefaults().boolForKey("sound") == true {
            var text = NSLocalizedString("GameScene_PauseBtnBgSound", tableName: nil, comment: "Sound")
            btnSound.setTitleText(text + "(" + NSLocalizedString("GameScene_SwitchOff", tableName: nil, comment: "Off") + ")")
        }
        else {
            var text = NSLocalizedString("GameScene_PauseBtnBgSound", tableName: nil, comment: "Sound")
            btnSound.setTitleText(text + "(" + NSLocalizedString("GameScene_SwitchOn", tableName: nil, comment: "On") + ")")
        }
        pauseNode.addChild(btnSound)
        
        var btnEffect = OzgSKButtonNode(normalImg: "btn1_up", downImg: "btn1_dw", disableImg: "btn1_dw", title: "Off")
        btnEffect.position = CGPointMake(180, 257)
        btnEffect.name = "btn_effect"
        btnEffect.setTouchedCallBack(self.onButton)
        if NSUserDefaults.standardUserDefaults().boolForKey("effect") == true {
            var text = NSLocalizedString("GameScene_PauseBtnEffect", tableName: nil, comment: "Effect")
            btnEffect.setTitleText(text + "(" + NSLocalizedString("GameScene_SwitchOff", tableName: nil, comment: "Off") + ")")
        }
        else {
            var text = NSLocalizedString("GameScene_PauseBtnEffect", tableName: nil, comment: "Effect")
            btnEffect.setTitleText(text + "(" + NSLocalizedString("GameScene_SwitchOn", tableName: nil, comment: "On") + ")")
        }
        pauseNode.addChild(btnEffect)
        
        var btnExit = OzgSKButtonNode(normalImg: "btn1_up", downImg: "btn1_dw", disableImg: "btn1_dw", title: NSLocalizedString("GameScene_PauseBtnQuit", tableName: nil, comment: "exit"))
        btnExit.position = CGPointMake(180, 150)
        btnExit.name = "btn_exit"
        btnExit.setTouchedCallBack(self.onButton)
        pauseNode.addChild(btnExit)
        
        var labGithub = SKLabelNode(text: "github:https://github.com/ouzhigang/OzgGameEatFishSwift")
        labGithub.position = CGPointMake(650, 320)
        labGithub.fontName = GameConfig.globalFontName01
        labGithub.fontSize = 20
        pauseNode.addChild(labGithub)
        
    }
    
    func onButton(sender: AnyObject!) {
        
        var btn: OzgSKButtonNode = sender as OzgSKButtonNode
        
        if btn.name! == "btn_pause" {
            //暂停游戏
            self.playEffectAudio("audios_btn.wav")
            self.scenePause()
            
        }
        else if btn.name! == "btn_resume" {
            //继续游戏
            self.playEffectAudio("audios_btn.wav")
            
            var fishNode = self.childNodeWithName("fish_node")
            for var i = 0; i < (fishNode?.children.count)!; i++ {
                var item: SKNode = (fishNode?.children[i])! as SKNode
                item.paused = false
                
            }
            
            self.m_isPauseUpdate = false
            self.enabledTouchEvent(true)
            
            var pauseNode = self.childNodeWithName("pause_node")
            pauseNode?.removeFromParent()
            
        }
        else if btn.name! == "btn_sound" {
            //背景音乐
            self.playEffectAudio("audios_btn.wav")
            
            if NSUserDefaults.standardUserDefaults().boolForKey("sound") == true {
                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "sound")
                self.enabledBgAudio(false)
                
                var text = NSLocalizedString("GameScene_PauseBtnBgSound", tableName: nil, comment: "Sound")
                btn.setTitleText(text + "(" + NSLocalizedString("GameScene_SwitchOn", tableName: nil, comment: "On") + ")")
            }
            else {
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "sound")
                self.enabledBgAudio(true)
                
                var text = NSLocalizedString("GameScene_PauseBtnBgSound", tableName: nil, comment: "Sound")
                btn.setTitleText(text + "(" + NSLocalizedString("GameScene_SwitchOff", tableName: nil, comment: "Off") + ")")
            }
            NSUserDefaults.standardUserDefaults().synchronize()
            
        }
        else if btn.name! == "btn_effect" {
            //效果声音
            self.playEffectAudio("audios_btn.wav")
            
            if NSUserDefaults.standardUserDefaults().boolForKey("effect") == true {
                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "effect")
                
                var text = NSLocalizedString("GameScene_PauseBtnEffect", tableName: nil, comment: "Effect")
                btn.setTitleText(text + "(" + NSLocalizedString("GameScene_SwitchOn", tableName: nil, comment: "On") + ")")
            }
            else {
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "effect")
                
                var text = NSLocalizedString("GameScene_PauseBtnEffect", tableName: nil, comment: "Effect")
                btn.setTitleText(text + "(" + NSLocalizedString("GameScene_SwitchOff", tableName: nil, comment: "Off") + ")")
            }
            NSUserDefaults.standardUserDefaults().synchronize()
            
        }
        else if btn.name! == "btn_exit" {
            //退出游戏
            
            var alert = UIAlertView(title: NSLocalizedString("Alert_Title", tableName: nil, comment: "title"), message: NSLocalizedString("GameScene_AlertMessage", tableName: nil, comment: "message"), delegate: self, cancelButtonTitle: NSLocalizedString("GameScene_AlertBtnNo", tableName: nil, comment: "no"), otherButtonTitles: NSLocalizedString("GameScene_AlertBtnYes", tableName: nil, comment: "yes"))
            alert.tag = 1
            alert.show()
            
        }
        else if btn.name! == "btn_next" {
            //下一关
            
            self.m_stageNum = self.m_stageNum! + 1
            if self.m_stageNum! > GameConfig.maxStage {
                self.m_stageNum = GameConfig.maxStage
            }
            
            var stageNumLab = self.childNodeWithName("stageNumLab") as SKLabelNode?
            stageNumLab?.text = NSLocalizedString("GameScene_LabStage", tableName: nil, comment: "Stage").stringByAppendingFormat("%i", self.m_stageNum!)
            
            self.m_eatFish = 0
            self.m_eatFishTotal = 0
            self.m_eatFishTotalType1And2 = 0
            self.m_eatFishTotalType3 = 0
            self.m_eatFishTotalType4 = 0
            
            var progress = self.childNodeWithName("progress") as SKSpriteNode?
            progress?.xScale = 0
            
            var clearNode = self.childNodeWithName("clearNode")
            clearNode?.removeFromParent()
            
            var fishNode = self.childNodeWithName("fish_node")
            
            self.m_isPauseUpdate = true
            var player = EFObjPlayerNode()
            player.name = "player"
            player.position = CGPointMake(self.size.width / 2, 800)
            fishNode?.addChild(player)
            player.invincible()
            
            self.gameStart()
        }
        else if btn.name! == "btn_restart" {
            //重新开始
            
            self.m_score = 0
            self.m_stageNum = 1
            self.m_playerLife = GameConfig.players
            self.m_eatFish = 0
            self.m_eatFishTotal = 0
            self.m_eatFishTotalType1And2 = 0
            self.m_eatFishTotalType3 = 0
            self.m_eatFishTotalType4 = 0
            
            var stageNumLab = self.childNodeWithName("stageNumLab") as SKLabelNode?
            stageNumLab?.text = NSLocalizedString("GameScene_LabStage", tableName: nil, comment: "Stage").stringByAppendingFormat("%i", self.m_stageNum!)
            
            var scoreLab = self.childNodeWithName("scoreLab") as SKLabelNode?
            scoreLab?.text = NSLocalizedString("GameScene_LabScore", tableName: nil, comment: "Score").stringByAppendingFormat("%i", self.m_score!)
            
            var fishLifeLab = self.childNodeWithName("fishLifeLab") as SKLabelNode?
            fishLifeLab?.text = String(self.m_playerLife!)
            
            var progress = self.childNodeWithName("progress") as SKSpriteNode?
            progress?.xScale = 0.0
            
            var gameoverNode = self.childNodeWithName("gameoverNode")
            gameoverNode?.removeFromParent()
            
            var fishNode = self.childNodeWithName("fish_node")
            var player = EFObjPlayerNode()
            player.name = "player"
            player.position = CGPointMake(self.size.width / 2, 800)
            fishNode?.addChild(player)
            player.invincible()
            
            self.gameStart()
        }
        
    }
    
    func enemyFishEmergence(enemyFishNode: EFObjBaseEnemyFishNode) {
        var startPoint: CGPoint?
        var endPoint: CGPoint?
        
        var fishNode = self.childNodeWithName("fish_node")
        
        //0.5为左边右边的机率各为50%
        if OzgSwiftUtility.randomRange(0, maxValue: 1) <= 0.5 {
            //左边出现
            startPoint = self.enemyFishRandomLeftPoint(enemyFishNode)
            endPoint = self.enemyFishRandomRightPoint(enemyFishNode)
            enemyFishNode.orientationRight() //左边出现需要面向右边
        }
        else {
            //右边出现
            startPoint = self.enemyFishRandomRightPoint(enemyFishNode)
            endPoint = self.enemyFishRandomLeftPoint(enemyFishNode)
            enemyFishNode.orientationLeft() //右边出现需要面向左边
        }
        
        enemyFishNode.position = startPoint!
        fishNode?.addChild(enemyFishNode)
        
        var moveTime: Float = 20.0 - 10.0
        moveTime = 10.0 + (moveTime * OzgSwiftUtility.randomRange(0, maxValue: 1))
        
        enemyFishNode.m_isMoving = true
        
        if enemyFishNode.isKindOfClass(EFObjEnemyFishNode) {
            (enemyFishNode as EFObjEnemyFishNode).m_moveTime = moveTime
            (enemyFishNode as EFObjEnemyFishNode).m_moveStartPoint = startPoint
            (enemyFishNode as EFObjEnemyFishNode).m_moveEndPoint = endPoint
            
        }
        
        enemyFishNode.runAction(SKAction.moveTo(endPoint!, duration: NSTimeInterval(moveTime)), completion: {
            enemyFishNode.removeFromParent()
        })
        
    }
    
    func enemyFishRandomLeftPoint(enemyFishNode: EFObjBaseEnemyFishNode) -> CGPoint {
        
        var x = -enemyFishNode.fishSize().width / 2
        var minY = Float(enemyFishNode.fishSize().height / 2)
        var maxY = Float(self.size.height) - minY
        
        return CGPointMake(x, CGFloat(OzgSwiftUtility.randomRange(minY, maxValue: maxY)))
    
    }
    
    func enemyFishRandomRightPoint(enemyFishNode: EFObjBaseEnemyFishNode) -> CGPoint {
        
        var x = self.size.width + (enemyFishNode.fishSize().width / 2)
        var minY = Float(enemyFishNode.fishSize().height / 2)
        var maxY = Float(self.size.height) - minY
        
        return CGPointMake(x, CGFloat(OzgSwiftUtility.randomRange(minY, maxValue: maxY)))
        
    }
    
    //SKPhysicsContactDelegate
    func didBeginContact(contact: SKPhysicsContact) {
//        println("碰撞的回调" + contact.bodyA.contactTestBitMask.description + " " + contact.bodyB.contactTestBitMask.description)
        
        if contact.bodyA.contactTestBitMask == 1 {
            self.collisionPlayerToAny(contact.bodyA.node?.parent! as EFObjPlayerNode, target: contact.bodyB.node?.parent! as EFObjBaseEnemyFishNode)
        }
        else if contact.bodyB.contactTestBitMask == 1 {
            self.collisionPlayerToAny(contact.bodyB.node?.parent! as EFObjPlayerNode, target: contact.bodyA.node?.parent! as EFObjBaseEnemyFishNode)
        }
        else if contact.bodyA.contactTestBitMask == 3 {
            self.collisionEnemyToAny(contact.bodyA.node?.parent! as EFObjEnemyFishNode, target: contact.bodyB.node?.parent! as EFObjBaseFishNode)
        }
        else if contact.bodyB.contactTestBitMask == 3 {
            self.collisionEnemyToAny(contact.bodyB.node?.parent! as EFObjEnemyFishNode, target: contact.bodyA.node?.parent! as EFObjBaseFishNode)
        }
        
    }
    
    //UIAlertViewDelegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        switch alertView.tag {
            
        case 1:
            //退出游戏
            if buttonIndex == 1 {
                self.enabledTouchEvent(false)
                self.m_isPauseUpdate = true
                
                let scene = EFStartScene(fileNamed: "EFStartScene")
                var t = SKTransition.fadeWithDuration(GameConfig.transitionTime)
                scene.scaleMode = SKSceneScaleMode.AspectFit
                self.view?.presentScene(scene, transition: t)
            }
            
        default:
            println("no handle")
        }
        
    }
    
    //player碰撞
    func collisionPlayerToAny(player: EFObjPlayerNode, target: EFObjBaseEnemyFishNode) {
        
        var fishNode = self.childNodeWithName("fish_node")
        
        if target.isKindOfClass(EFObjEnemyFishNode) {
            
            var doEat = false
            if player.m_isMoving == true {
                
                switch player.m_status! {
                    
                case EFObjPlayerNode.Status.Normal:
                    //中的状态
                    if (target as EFObjEnemyFishNode).m_type! == EFObjEnemyFishNode.EnemyFishType.Fish1 ||
                        (target as EFObjEnemyFishNode).m_type! == EFObjEnemyFishNode.EnemyFishType.Fish2 ||
                        (target as EFObjEnemyFishNode).m_type! == EFObjEnemyFishNode.EnemyFishType.Fish3 {
                        doEat = true
                    }
                    
                    
                case EFObjPlayerNode.Status.Big:
                    //大的状态
                    if (target as EFObjEnemyFishNode).m_type! == EFObjEnemyFishNode.EnemyFishType.Fish1 ||
                        (target as EFObjEnemyFishNode).m_type! == EFObjEnemyFishNode.EnemyFishType.Fish2 ||
                        (target as EFObjEnemyFishNode).m_type! == EFObjEnemyFishNode.EnemyFishType.Fish3 ||
                    (target as EFObjEnemyFishNode).m_type! == EFObjEnemyFishNode.EnemyFishType.Fish4 {
                            doEat = true
                    }
                    
                default:
                    //小的状态
                    if (target as EFObjEnemyFishNode).m_type! == EFObjEnemyFishNode.EnemyFishType.Fish1 ||
                        (target as EFObjEnemyFishNode).m_type! == EFObjEnemyFishNode.EnemyFishType.Fish2 {
                            doEat = true
                    }
                }
                
                if doEat == true {
                    //吃掉比自己小的鱼
                    var audioList = [ "audios_eatfish1.mp3", "audios_eatfish2.mp3" ]
                    var audioIndex = Int(arc4random_uniform(UInt32(audioList.count)))
                    self.playEffectAudio(audioList[audioIndex])
                    
                    player.cump((target as EFObjEnemyFishNode).m_type!)
                    target.removeFromParent()
                    
                    //分数
                    self.changeScore((target as EFObjEnemyFishNode).m_type!)
                    
                    //关卡进度条
                    var cpProgress = CGFloat(self.m_eatFishTotal!) / CGFloat(GameConfig.stageClear)
                    
                    var progress = self.childNodeWithName("progress") as SKSpriteNode?
                    progress?.xScale = cpProgress
                    
                    if cpProgress >= 1 {
                        //过关
                        self.m_isPauseUpdate = true
                        self.playEffectAudio("audios_complete.mp3")
                        
                        self.enabledTouchEvent(false)
                        
                        //直接removeAllChildren会内存泄露
                        while fishNode?.children.last != nil {
                            (fishNode?.children.last as EFObjBaseFishNode).removeFromParent()
                        }
                        
                        //过关界面
                        var clearNode = SKNode()
                        clearNode.position = CGPoint.zeroPoint
                        clearNode.name = "clearNode"
                        self.addChild(clearNode)
                        
                        var clearBg = SKSpriteNode(imageNamed: "completebg")
                        clearBg.position = CGPointMake(self.size.width / 2, self.size.height / 2)
                        clearNode.addChild(clearBg)
                        
                        var fishNum = SKSpriteNode(imageNamed: "fishnum")
                        fishNum.position = CGPointMake(self.size.width / 2, self.size.height / 2)
                        clearNode.addChild(fishNum)
                        
                        var title = SKLabelNode(text: NSLocalizedString("GameScene_GameClearLab1", tableName: nil, comment: "Title"))
                        title.position = CGPointMake(self.size.width / 2, 480)
                        title.fontName = GameConfig.globalFontName01
                        title.fontSize = 50
                        clearNode.addChild(title)
                        
                        var gameClearLab1 = SKLabelNode(text: String((self.m_eatFishTotalType1And2?)!))
                        gameClearLab1.fontName = GameConfig.globalFontName01
                        gameClearLab1.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
                        gameClearLab1.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
                        gameClearLab1.position = CGPointMake(600, 392)
                        gameClearLab1.fontSize = 30
                        clearNode.addChild(gameClearLab1)
                        
                        var gameClearLab2 = SKLabelNode(text: String((self.m_eatFishTotalType3?)!))
                        gameClearLab2.fontName = GameConfig.globalFontName01
                        gameClearLab2.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
                        gameClearLab2.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
                        gameClearLab2.position = CGPointMake(600, 317)
                        gameClearLab2.fontSize = 30
                        clearNode.addChild(gameClearLab2)
                        
                        var gameClearLab3 = SKLabelNode(text: String((self.m_eatFishTotalType4?)!))
                        gameClearLab3.fontName = GameConfig.globalFontName01
                        gameClearLab3.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
                        gameClearLab3.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
                        gameClearLab3.position = CGPointMake(600, 242)
                        gameClearLab3.fontSize = 30
                        clearNode.addChild(gameClearLab3)
                        
                        var btnExit = OzgSKButtonNode(normalImg: "btn1_up", downImg: "btn1_dw", disableImg: "btn1_dw", title: NSLocalizedString("GameScene_GameClearBtnQuit", tableName: nil, comment: "Quit"))
                        btnExit.position = CGPointMake(280, 120)
                        btnExit.name = "btn_exit"
                        btnExit.setTouchedCallBack(self.onButton)
                        clearNode.addChild(btnExit)
                        
                        var btnNext = OzgSKButtonNode(normalImg: "btn1_up", downImg: "btn1_dw", disableImg: "btn1_dw", title: NSLocalizedString("GameScene_GameClearBtnNext", tableName: nil, comment: "Next"))
                        btnNext.position = CGPointMake(self.size.width - 280, 120)
                        btnNext.name = "btn_next"
                        btnNext.setTouchedCallBack(self.onButton)
                        clearNode.addChild(btnNext)
                        
                    }
                    
                    //变大的判断
                    if player.m_status == EFObjPlayerNode.Status.Normal && self.m_eatFish! >= GameConfig.playerStatusBig {
                        self.playEffectAudio("audios_growth.mp3")
                        player.changeStatus(EFObjPlayerNode.Status.Big)
                    }
                    else if player.m_status == EFObjPlayerNode.Status.Small && self.m_eatFish! >= GameConfig.playerStatusNormal {
                        self.playEffectAudio("audios_growth.mp3")
                        player.changeStatus(EFObjPlayerNode.Status.Normal)
                    }
                    
                }
                else {
                    //如果在可控制状态下，不是无敌状态的话，就会被比自己大的鱼吃了
                    
                    if player.m_isMoving! == true && player.m_isInvincible! == false {
                        target.cump()
                        player.removeFromParent()
                        
                        self.enabledTouchEvent(false)
                        
                        if self.m_playerLife! == 0 {
                            //没有了生命值就game over
                            
                            self.m_isPauseUpdate = true
                            self.playEffectAudio("audios_complete.mp3")
                            
                            self.enabledTouchEvent(false)
                            
                            while fishNode?.children.last != nil {
                                (fishNode?.children.last as EFObjBaseFishNode).removeFromParent()
                            }
                            
                            //game over界面
                            var gameoverNode = SKNode()
                            gameoverNode.name = "gameoverNode"
                            gameoverNode.position = CGPoint.zeroPoint
                            self.addChild(gameoverNode)
                            
                            var gameoverBg = SKSpriteNode(imageNamed: "completebg")
                            gameoverBg.position = CGPointMake(self.size.width / 2, self.size.height / 2)
                            gameoverNode.addChild(gameoverBg)
                            
                            var title = SKLabelNode(text: NSLocalizedString("GameScene_GameOverLab1", tableName: nil, comment: "title"))
                            title.fontName = GameConfig.globalFontName01
                            title.fontSize = 50
                            title.position = CGPointMake(self.size.width / 2, 470)
                            gameoverNode.addChild(title)
                            
                            var content = SKLabelNode(text: NSLocalizedString("GameScene_GameOverLab2", tableName: nil, comment: "content"))
                            content.fontName = GameConfig.globalFontName01
                            content.fontSize = 30
                            content.position = CGPointMake(self.size.width / 2, 390)
                            gameoverNode.addChild(content)
                            
                            var btnExit = OzgSKButtonNode(normalImg: "btn1_up", downImg: "btn1_dw", disableImg: "btn1_dw", title: NSLocalizedString("GameScene_GameOverBtnQuit", tableName: nil, comment: "Quit"))
                            btnExit.position = CGPointMake(280, 120)
                            btnExit.name = "btn_exit"
                            btnExit.setTouchedCallBack(self.onButton)
                            gameoverNode.addChild(btnExit)
                            
                            var btnRestart = OzgSKButtonNode(normalImg: "btn1_up", downImg: "btn1_dw", disableImg: "btn1_dw", title: NSLocalizedString("GameScene_GameOverBtnRestart", tableName: nil, comment: "Next"))
                            btnRestart.position = CGPointMake(self.size.width - 280, 120)
                            btnRestart.name = "btn_restart"
                            btnRestart.setTouchedCallBack(self.onButton)
                            gameoverNode.addChild(btnRestart)
                            
                        }
                        else {
                            self.m_eatFish = 0
                            self.playEffectAudio("audios_playbyeat.mp3")
                            
                            self.m_playerLife = self.m_playerLife! - 1
                            var fishLifeLab = self.childNodeWithName("fishLifeLab") as SKLabelNode?
                            fishLifeLab?.text = String(self.m_playerLife!)
                            self.runAction(SKAction.waitForDuration(2.5), completion: {
                                
                                var fishNode = self.childNodeWithName("fish_node")
                                
                                var player = EFObjPlayerNode()
                                player.name = "player"
                                player.position = CGPointMake(self.size.width / 2, 800)
                                fishNode?.addChild(player)
                                player.invincible()
                                
                                self.gameStart()
                            })
                        }
                        
                    }
                }
                
            }
            
        }
        else if target.isKindOfClass(EFObjJellyfishNode) {
            
            if player.m_isInvincible! == false {
                self.playEffectAudio("audios_jellyfish.mp3")
                player.paralysis()
            }
            
        }
        
    }
    
    //enemy碰撞
    func collisionEnemyToAny(enemy: EFObjEnemyFishNode, target: EFObjBaseFishNode) {
        
        if target.isKindOfClass(EFObjEnemyFishNode) {
            
            if enemy.m_type!.hashValue > EFObjEnemyFishNode.EnemyFishType.Fish2.hashValue || (target as EFObjEnemyFishNode).m_type!.hashValue > EFObjEnemyFishNode.EnemyFishType.Fish2.hashValue {
                
                //大鱼吃小鱼
                
                if enemy.m_type!.hashValue > (target as EFObjEnemyFishNode).m_type!.hashValue {
                    enemy.cump()
                    (target as EFObjEnemyFishNode).removeFromParent()
                }
                else if (target as EFObjEnemyFishNode).m_type!.hashValue > enemy.m_type!.hashValue {
                    (target as EFObjEnemyFishNode).cump()
                    enemy.removeFromParent()
                }
                
            }
            
        }
        else if target.isKindOfClass(EFObjJellyfishNode) {
            
            //鲨鱼不执行
            if enemy.m_type!.hashValue < EFObjEnemyFishNode.EnemyFishType.Fish5.hashValue {
                self.playEffectAudio("audios_jellyfish.mp3")
                enemy.paralysis()
            }
            
        }
        
    }
    
    func changeScore(type: EFObjEnemyFishNode.EnemyFishType) {
        
        switch type {
        case EFObjEnemyFishNode.EnemyFishType.Fish2:
            
            self.m_score = self.m_score! + GameConfig.scoreFish2
            self.m_eatFish = self.m_eatFish! + GameConfig.scoreFish2
            self.m_eatFishTotal = self.m_eatFishTotal! + 1
            self.m_eatFishTotalType1And2 = self.m_eatFishTotalType1And2! + 1
            
        case EFObjEnemyFishNode.EnemyFishType.Fish3:
            
            self.m_score = self.m_score! + GameConfig.scoreFish3
            self.m_eatFish = self.m_eatFish! + GameConfig.scoreFish3
            self.m_eatFishTotal = self.m_eatFishTotal! + 1
            self.m_eatFishTotalType3 = self.m_eatFishTotalType3! + 1
            
        case EFObjEnemyFishNode.EnemyFishType.Fish4:
            
            self.m_score = self.m_score! + GameConfig.scoreFish4
            self.m_eatFish = self.m_eatFish! + GameConfig.scoreFish4
            self.m_eatFishTotal = self.m_eatFishTotal! + 1
            self.m_eatFishTotalType4 = self.m_eatFishTotalType4! + 1
            
        default:
            
            self.m_score = self.m_score! + GameConfig.scoreFish1
            self.m_eatFish = self.m_eatFish! + GameConfig.scoreFish1
            self.m_eatFishTotal = self.m_eatFishTotal! + 1
            self.m_eatFishTotalType1And2 = self.m_eatFishTotalType1And2! + 1
            
        }
        
        if self.m_score! > GameConfig.maxScore {
            self.m_score = GameConfig.maxScore
        }
        
        if self.m_eatFish! > GameConfig.maxScore {
            self.m_eatFish = GameConfig.maxScore
        }
        
        if self.m_eatFishTotal! > GameConfig.maxScore {
            self.m_eatFishTotal = GameConfig.maxScore
        }
        
        var scoreLab = self.childNodeWithName("scoreLab") as SKLabelNode?
        scoreLab?.text = NSLocalizedString("GameScene_LabScore", tableName: nil, comment: "Score").stringByAppendingFormat("%i", self.m_score!)
        
    }
    
    func enabledTouchEvent(val: Bool) {
        self.userInteractionEnabled = val
        
        var btnPause = self.childNodeWithName("btn_pause")
        btnPause?.userInteractionEnabled = val
    }
    
}
