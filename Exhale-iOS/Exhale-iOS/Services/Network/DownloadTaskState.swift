import Foundation

enum DownloadTaskState {
    case loading(progress: Float)
    case pause, cancel, starting, none
    case done(location: URL)
}
