
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
    
    //字体
    class var globalFontName01: String {
        
        return "Arial-BoldMT"
    }
    class var globalFontName02: String {
        
        return "Arial-BoldItalicMT"
    }
    
}
