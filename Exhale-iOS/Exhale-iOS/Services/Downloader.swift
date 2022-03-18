import Foundation

protocol DownloadProtocol {
    func download(from url: URL, completion: @escaping (_ location: URL?, _ error: Error?) -> Void)
    func resume(url: URL)
    func pause(url: URL)
    func cancel(url: URL)
}

final class Downloader: NSObject, DownloadProtocol {
    private var tasks = [URL: URLSessionDownloadTask]()
    
    func download(from url: URL, completion: @escaping (_ location: URL?, _ error: Error?) -> Void) {
        DispatchQueue.global().async {
            let session = URLSession(configuration: .default, delegate: self, delegateQueue: .current)
            let task = session.downloadTask(with: url) { location, _, error in
                completion(location, error)
            }
            
            self.tasks[url] = task
            task.resume()
        }
    }
    
    func resume(url: URL) {
        tasks[url]?.resume()
    }
    
    func pause(url: URL) {
        tasks[url]?.progress.pause()
    }

    func cancel(url: URL) {
        tasks[url]?.cancel()
    }
}


extension Downloader: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("finished: \(location)")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        print(progress)
    }
}
