import Foundation

protocol DownloadDelegate {
    func updateState(_ state: DownloadTaskState, at indexPath: IndexPath)
}
