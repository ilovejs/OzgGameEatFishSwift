
import Foundation
import SpriteKit

class EFGameScene: EFBaseScene, SKPhysicsContactDelegate {
    
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
        self.addChild(stageNumLab)
        
        var scoreLab = SKLabelNode(text: NSLocalizedString("GameScene_LabScore", tableName: nil, comment: "Score").stringByAppendingFormat("%i", self.m_score!))
        scoreLab.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        scoreLab.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        scoreLab.position = CGPointMake(750, 560)
        scoreLab.fontSize = 28
        scoreLab.fontName = GameConfig.globalFontName01
        scoreLab.name = "scoreLab"
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
        fishLifeLab.name = "fishLifeLab"
        self.addChild(fishLifeLab)
        
        //player
        self.m_isPauseUpdate = true
        var player = EFObjPlayerNode()
        player.name = "player"
        player.position = CGPointMake(self.size.width / 2, 800)
        fishNode.addChild(player)
        player.invincible()
        
        self.enabledTouchEvent(false)
        
        self.gameStart()
        
    }
    
    override func willMoveFromView(view: SKView) {
        
    }
    
    override func update(currentTime: NSTimeInterval) {
        
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
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        
        var fishNode = self.childNodeWithName("fish_node")
        var player = fishNode?.childNodeWithName("player") as EFObjPlayerNode?
//        if player != nil && ((player as EFObjPlayerNode?)?.m_isMoving)! == true {
        if player != nil {
            var touch: UITouch? = touches.anyObject() as UITouch?
            
            var beginPoint =  touch?.locationInNode(self)
            var endPoint = touch?.previousLocationInNode(self)
            var offset = CGPointMake((beginPoint?.x)! - (endPoint?.x)!, (beginPoint?.y)! - (endPoint?.y)!)
            var toPoint = CGPointMake((player?.position.x)! + offset.x, (player?.position.y)! + offset.y)
            
            player?.position = toPoint
            
            var toX = (player?.position.x)!
            var toY = (player?.position.y)!
            
            var rect = CGRectMake((player?.position.x)!, (player?.position.y)!, (player?.fishSize().width)!, (player?.fishSize().height)!)
            var moveRect = CGRectMake(rect.size.width / 2, rect.size.height / 2, self.frame.width - (rect.size.width / 2), self.frame.height - (rect.size.height / 2))
         
            //如果toPoint的x存在moveRect的宽度范围里面则x为可移动，y的情况一样
            if toPoint.x >= moveRect.origin.x && toPoint.x <= moveRect.size.width {
                toX = toPoint.x
            }
            if toPoint.y >= moveRect.origin.y && toPoint.y <= moveRect.size.height {
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
    
    func didBeginContact(contact: SKPhysicsContact) {
//        println("碰撞的回调" + contact.bodyA.contactTestBitMask.description + " " + contact.bodyB.contactTestBitMask.description)
        
        if contact.bodyA.contactTestBitMask == 1 {
            self.collisionPlayerToAny(contact.bodyA.node?.parent! as EFObjPlayerNode, target: contact.bodyB.node?.parent! as EFObjBaseEnemyFishNode)
        }
        else if contact.bodyB.contactTestBitMask == 1 {
            self.collisionPlayerToAny(contact.bodyB.node?.parent! as EFObjPlayerNode, target: contact.bodyA.node?.parent! as EFObjBaseEnemyFishNode)
        }
        
    }
    
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
                        fishNode?.removeAllChildren()
                        
                        //过关界面
                        
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
                
                }
                
            }
            
        }
        else if target.isKindOfClass(EFObjJellyfishNode) {
            
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
            self.m_eatFishTotalType1And2 = self.m_eatFishTotalType3! + 1
            
        case EFObjEnemyFishNode.EnemyFishType.Fish4:
            
            self.m_score = self.m_score! + GameConfig.scoreFish4
            self.m_eatFish = self.m_eatFish! + GameConfig.scoreFish4
            self.m_eatFishTotal = self.m_eatFishTotal! + 1
            self.m_eatFishTotalType1And2 = self.m_eatFishTotalType4! + 1
            
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
