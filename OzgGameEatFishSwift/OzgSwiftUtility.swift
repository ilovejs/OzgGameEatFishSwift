
import Foundation

class OzgSwiftUtility {
    
    //范围随机
    class func randomRange(minValue: Float, maxValue: Float) -> Float {
        
        var random01 = Float(Float(arc4random()) / Float(UINT32_MAX))
        
        var val = maxValue - minValue;
        val = minValue + (val * random01);
        return val;
    }
    
}
