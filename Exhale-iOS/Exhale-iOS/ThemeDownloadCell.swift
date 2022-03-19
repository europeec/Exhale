import UIKit

final class ThemeDownloadCell: UITableViewCell {
    static let identifier = "ThemeDownloadCell"
    static let nib = UINib(nibName: identifier, bundle: nil)
    
    private var theme: Theme?
    private var downloader: Downloader?
    
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
    
    func configure(theme: Theme) {
        setup()
        self.theme = theme
        guard let theme = self.theme else { return }
        downloader = Downloader(url: theme.url, delegate: self)
    }
    
    func setup() {
        
        addSubview(progressBar)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            downloader?.download()
        }
    }
}

extension ThemeDownloadCell: DownloadDelegate {
    func updateState(_ state: DownloadTaskState, for taskURL: URL) {
        print(state)

        switch state {
        case .loading(let progress):
            progressBar.progress = progress
        case .pause:
            progressBar.progressTintColor = .cyan
        case .cancel, .starting:
            break
        case .done(let location):
            progressBar.progressTintColor = .green
        }
    }
}
