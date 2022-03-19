import Foundation

enum DownloadTaskState {
    case loading(progress: Float)
    case pause, cancel, starting
    case done(location: URL)
}
