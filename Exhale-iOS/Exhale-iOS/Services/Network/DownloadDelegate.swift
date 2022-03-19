import Foundation

protocol DownloadDelegate {
    func updateState(_ state: DownloadTaskState, for taskURL: URL)
}
