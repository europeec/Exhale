import Foundation

protocol DownloadProtocol {
    func download(from url: URL, at indexPath: IndexPath)
    func resume(at indexPath: IndexPath)
    func pause(at indexPath: IndexPath)
    func cancel(at indexPath: IndexPath)
}

final class Downloader: NSObject, DownloadProtocol {
    private let delegate: DownloadDelegate
    
    private var tasks = [IndexPath: URLSessionDownloadTask]()
    private var resumeData = [IndexPath: Data]()
    
    init(progressDelegate delegate: DownloadDelegate) {
        self.delegate = delegate
    }
    
    func download(from url: URL, at indexPath: IndexPath) {
        DispatchQueue.global().async {
            if self.tasks[indexPath] == nil {
                let session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
                let task = session.downloadTask(with: url)
                task.resume()
                
                self.tasks[indexPath] = task
        
            } else {
                self.resume(at: indexPath)
            }
        }
    }
    
    func resume(at indexPath: IndexPath) {
        guard let url = tasks[indexPath]?.currentRequest?.url else { return }
        
        if let data = resumeData[indexPath] {
            let session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
            let task = session.downloadTask(withResumeData: data)
            task.resume()
            tasks[indexPath] = task
        } else {
            tasks[indexPath] = nil
            download(from: url, at: indexPath)
        }
    }
    
    func pause(at indexPath: IndexPath) {
        tasks[indexPath]?.cancel(byProducingResumeData: { data in
            if data != nil {
                self.resumeData[indexPath] = data
            }
        })
        delegate.updateState(.pause, at: indexPath)
    }

    func cancel(at indexPath: IndexPath) {
        tasks[indexPath]?.cancel()
        tasks[indexPath] = nil
        resumeData[indexPath] = nil
        delegate.updateState(.cancel, at: indexPath)
    }
    
//    func done(for url: URL) {
//        tasks[url] = nil
//        resumeData[url] = nil
//
//        print("Done, count tasks: \(tasks.count), resumeData: \(resumeData.count)")
//    }
    
    private func getIndexPath(from task: URLSessionDownloadTask) -> IndexPath? {
        guard let indexPath = tasks.filter({ $0.value == task }).first?.key else { return nil }
        return indexPath
    }
}

extension Downloader: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        guard let indexPath = getIndexPath(from: downloadTask) else { return }
        delegate.updateState(.done(location: location), at: indexPath)
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard let indexPath = getIndexPath(from: downloadTask) else { return }
        
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        delegate.updateState(.loading(progress: progress), at: indexPath)
    }
}
