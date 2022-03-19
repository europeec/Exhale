import Foundation

protocol DownloadProtocol {
    init(url: URL, delegate: DownloadDelegate)
    func download()
    func resume()
    func pause()
    func cancel()
}

final class Downloader: NSObject, DownloadProtocol {
    private let url: URL
    private let delegate: DownloadDelegate
    
    private var task: URLSessionDownloadTask?
    
    required init(url: URL, delegate: DownloadDelegate) {
        self.url = url
        self.delegate = delegate
    }
    
    func download() {
        DispatchQueue.global().async {
            self.delegate.updateState(.starting, for: self.url)
            let session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
            let task = session.downloadTask(with: self.url)
            task.resume()
        }
    }
    
    func resume() {
        task?.resume()
    }
    
    func pause() {
        delegate.updateState(.pause, for: url)
        task?.progress.pause()
    }

    func cancel() {
        delegate.updateState(.cancel, for: url)
        task?.cancel()
        task = nil
    }
}


extension Downloader: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        delegate.updateState(.done(location: location), for: url)
        task = nil
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        delegate.updateState(.loading(progress: progress), for: url)
    }
}
