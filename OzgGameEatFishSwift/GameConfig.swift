
import Foundation
import SpriteKit

class GameConfig {
    
    //player默认的生命值
    class var players: Int {
        
        return 2
    }
    
    //水母每帧的出现机率 1/2000的机率
    class var enemyJellyfish: Float {
        return 0.0005
    }
    
    //各个AI鱼的出现机率
    class var enemyFish1: Float {
        return 0.05
    }
    class var enemyFish2: Float {
        return 0.05
    }
    class var enemyFish3: Float {
        return 0.00625
    }
    class var enemyFish4: Float {
        return 0.00375
    }
    class var enemyFish5: Float {
        return 0.00125
    }
    class var enemyFish6: Float {
        return 0.00125
    }
    
    //吃了一条鱼所加的分数
    class var scoreFish1: Int {
        return 1
    }
    class var scoreFish2: Int {
        return 1
    }
    class var scoreFish3: Int {
        return 2
    }
    class var scoreFish4: Int {
        return 3
    }
    
    //最高分数
    class var maxScore: Int {
        return 99999
    }
    
    //最高关卡
    class var maxStage: Int {
        return 99
    }
    
    //吃够多少条鱼过一关
    class var stageClear: Int {
        return 2 //小鱼+1，中鱼+2，大鱼+3
    }
    
    //升级到中等或大的所需分数
    class var playerStatusNormal: Int {
        return 145 //这个值必须为stageClear的29%
    }
    class var playerStatusBig: Int {
        return 305 //这个值必须为stageClear的61%
    }
    
    //过场时间
    class var transitionTime: NSTimeInterval {
        
        return 0.5
    }
    
    //玩家的初始化无敌时间
    class var invincibleTime: NSTimeInterval {
        
        return 4.0
    }
    
    //玩家使用道具获得的无敌时间
    class var invincibleTime2: NSTimeInterval {
        
        return 30.0
    }
        
    //字体
    class var globalFontName01: String {
        
        return "Arial-BoldMT"
    }
    class var globalFontName02: String {
        
        return "Arial-BoldItalicMT"
    }
    
}
