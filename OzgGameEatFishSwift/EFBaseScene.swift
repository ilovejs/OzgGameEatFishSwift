
import Foundation
import AVFoundation
import SpriteKit

class EFBaseScene: SKScene, AVAudioPlayerDelegate {
    
    var m_effectAudioList: Array<AVAudioPlayer>?
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        var player = EFBaseScene.shareBgAudio
        if player?.playing != true {
            player?.numberOfLoops = -1
            player?.delegate = self
            player?.play()
        }
        
    }
    
    class var shareBgAudio: AVAudioPlayer? {
        struct Static {
            static let instance: AVAudioPlayer? = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("audios_bg", ofType: "mp3")!), error: nil)
        }
        return Static.instance
    }
    
    func playEffectAudio(audio: String) {
        
        if self.m_effectAudioList == nil {
            self.m_effectAudioList = []
        }
        
        var player: AVAudioPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(audio.stringByDeletingPathExtension, ofType: audio.pathExtension)!), error: nil)
        player.numberOfLoops = 0
        player.delegate = self
        self.m_effectAudioList?.append(player)
        player.play()
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        
        for var i = 0; i < self.m_effectAudioList?.count; i++ {
            if (self.m_effectAudioList?[i])! == player {
                self.m_effectAudioList?.removeAtIndex(i)
            }
        }
    }
    
}
