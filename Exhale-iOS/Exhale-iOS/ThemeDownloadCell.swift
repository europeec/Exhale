import UIKit

final class ThemeDownloadCell: UITableViewCell {
    static let identifier = "ThemeDownloadCell"
    
    private var theme: Theme?
    private var indexPath: IndexPath?
    private var delegate: ThemeDownloadCellDelegate?

    var isLoading = false
    var isDone = false
    
    private lazy var progressBar: UIProgressView = {
        let progress = UIProgressView()
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            progressBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            progressBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            progressBar.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configure(theme: Theme, delegate: ThemeDownloadCellDelegate, at indexPath: IndexPath) {
        setup()
        self.theme = theme
        self.delegate = delegate
        self.indexPath = indexPath
    }
    
    func select() {
        guard let indexPath = indexPath else { return }
        
        if !isDone {
            if isLoading {
                delegate?.cell(at: indexPath, didUpdateState: .pause)
                print("Pause")
            } else {
                print("Starting..")
                delegate?.cell(at: indexPath, didUpdateState: .starting)
            }
            
            isLoading = !isLoading
        }
    }
    
    private func setup() {
        addSubview(progressBar)
    }

}

extension ThemeDownloadCell: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        isDone = true
        guard let indexPath = indexPath else { return }
        
        delegate?.cell(at: indexPath, didUpdateState: .done(location: location))
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {

        guard let indexPath = indexPath else { return }

        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        progressBar.progress = progress

        delegate?.cell(at: indexPath, didUpdateState: .loading(progress: progress))
    }
}
