import UIKit
import AVFoundation

final class VideoPlayerLayer: AVPlayerLayer {
    private var paused = false

    override init() {
        super.init()
        
        player = AVPlayer()
        videoGravity = .resizeAspectFill
        contentsGravity = .left
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func play(from url: URL) {
        let playerItem = AVPlayerItem(url: url)
        player?.replaceCurrentItem(with: playerItem)
        player?.play()
        paused = false
    }
    
    func resume() {
        if paused {
            player?.play()
            paused = false 
        }
    }
    
    func pause() {
        paused = true
    }
}
