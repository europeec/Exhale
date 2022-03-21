import UIKit

final class ThemeDownloadCell: UITableViewCell {
    static let identifier = "ThemeDownloadCell"
    
    private var theme: Theme?
    private var indexPath: IndexPath?
//    private weak var delegate: ThemeDownloadCellDelegate?
    
    private var state: DownloadTaskState = .starting
    
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
    
    func configure(data: ThemeDownloadCellModel) {
        setup()
        theme = data.theme
        state = .starting
        progressBar.progress = data.progress
    }
    
    private func setup() {
        addSubview(progressBar)
    }
    
    func updateState(_ state: DownloadTaskState) {
        switch state {
        case .loading(let progress):
            progressBar.progress = progress
        case .pause:
            print("pause")
        case .cancel:
            print("cancel")
        case .starting:
            print("starting")
        case .done(_):
            print("done")
        }
        
    }

}
//
//extension ThemeDownloadCell: URLSessionDownloadDelegate {
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
//        
//        isDone = true
//        guard let indexPath = indexPath else { return }
//        
//        delegate?.cell(at: indexPath, didUpdateState: .done(location: location))
//    }
//    
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
//
//        guard let indexPath = indexPath else { return }
//
//        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
//        progressBar.progress = progress
//
//        delegate?.cell(at: indexPath, didUpdateState: .loading(progress: progress))
//    }
//}
