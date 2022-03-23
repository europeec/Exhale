import Foundation

final class ThemeDownloadCellModel {
    let theme: Theme
    var state: DownloadTaskState
    var progress: Float = 0
    
    init(theme: Theme, state: DownloadTaskState) {
        self.theme = theme
        self.state = state
    }
}
