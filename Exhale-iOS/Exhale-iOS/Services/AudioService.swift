import AVFoundation

protocol AudioServiceProtocol {
    func play(filename: String, type: String, fadeDuration: TimeInterval)
    func pause()
    func stop()
    func setVolume(_ volume: Float, fadeDuration: TimeInterval)
}

final class AudioService: AudioServiceProtocol {
    private enum Constant {
        static let defaultVolume: Float = 0.5
        static let defaultFadeDuration: TimeInterval = 0.5
    }

    static let shared = AudioService()
    
    private var player: AVAudioPlayer?
    private var volume = Constant.defaultVolume
    
    func play(filename: String,
              type: String,
              fadeDuration: TimeInterval = Constant.defaultFadeDuration) {
        guard
            let urlString = Bundle.main.path(forResource: filename, ofType: type),
            let url = URL(string: urlString)
        else {
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()

        } catch let error {
            fatalError(error.localizedDescription)
        }
        
        player?.volume = 0
        player?.play()
        
        player?.setVolume(volume, fadeDuration: fadeDuration)
    }
    
    func pause() {
        player?.pause()
    }
    
    func stop() {
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        player?.stop()
    }
    
    func setVolume(_ volume: Float, fadeDuration: TimeInterval) {
        self.volume = volume

        guard let player = player else {
            return
        }

        player.setVolume(volume, fadeDuration: fadeDuration)
    }
}
