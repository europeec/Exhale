import UIKit
import AVFoundation

final class VideoPlayerLayer: AVPlayerLayer {
    private var paused = false
    
    private let statusObserver: VideoPlayerLayerDelegate
    
    init(statusObserver: VideoPlayerLayerDelegate) {
        self.statusObserver = statusObserver
        super.init()
        
        player = AVPlayer()
        videoGravity = .resizeAspectFill
        contentsGravity = .left
        
        setupObserver()
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
        player?.pause()
    }
    
    private func setupObserver() {
        guard let player = player else { return }
        
        // For loop video
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main) { _ in
                player.seek(to: CMTime.zero)
                player.play()
            }
        
        // Observer for state of player
        player.addObserver(self, forKeyPath: "status", options: [.old, .new], context: nil)
        player.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let player = player else { return }
        
        if keyPath == "status" {
            switch player.status {
            case .unknown, .failed:
                statusObserver.videoLayer(self, updateStatus: .error)
            case .readyToPlay:
                statusObserver.videoLayer(self, updateStatus: .readyForPlay)
            @unknown default:
                fatalError()
            }
        } else if keyPath == "timeControlStatus" {
            switch player.timeControlStatus {
            case .paused, .waitingToPlayAtSpecifiedRate:
                break
            case .playing:
                statusObserver.videoLayer(self, updateStatus: .playing)
            @unknown default:
                fatalError()
            }
        }
    }
}
