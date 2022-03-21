import Foundation

protocol DownloadProtocol {
    func download(from url: URL,
                  progressDelegate: URLSessionDownloadDelegate)
    
    func resume(for url: URL, progressDelegate: URLSessionDownloadDelegate)
    func pause(for url: URL)
    func cancel(for url: URL)
    func done(for url: URL)
}

final class Downloader: NSObject, DownloadProtocol {
    private var tasks = [URL: URLSessionDownloadTask]()
    private var resumeData = [URL: Data]()
    
    func download(from url: URL, progressDelegate delegate: URLSessionDownloadDelegate) {
        DispatchQueue.global().async {
            if self.tasks[url] == nil {
                let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: .main)
                let task = session.downloadTask(with: url)
                task.resume()
                
                self.tasks[url] = task
            } else {
                self.resume(for: url, progressDelegate: delegate)
            }
        }
    }
    
    func resume(for url: URL, progressDelegate delegate: URLSessionDownloadDelegate) {
        if let data = resumeData[url] {
            let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: .main)
            let task = session.downloadTask(withResumeData: data)
            task.resume()
            
            tasks[url] = task
        } else {
            tasks[url] = nil
            download(from: url, progressDelegate: delegate)
        }
    }
    
    func pause(for url: URL) {
        tasks[url]?.cancel(byProducingResumeData: { data in
            if data != nil {
                self.resumeData[url] = data
            }
        })
    }

    func cancel(for url: URL) {
        tasks[url]?.cancel()
        tasks[url] = nil
        resumeData[url] = nil
    }
    
    func done(for url: URL) {
        tasks[url] = nil
        resumeData[url] = nil
        
        print("Done, count tasks: \(tasks.count), resumeData: \(resumeData.count)")
    }
}
