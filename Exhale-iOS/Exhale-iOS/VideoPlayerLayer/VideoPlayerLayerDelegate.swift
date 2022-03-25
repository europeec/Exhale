import AVFoundation

protocol VideoPlayerLayerDelegate {
    func videoLayer(_ layer: VideoPlayerLayer, updateStatus status: VideoPlayerLayerState)
}
