import Foundation

final class ThemeDownloadCellModel {
    let theme: Theme
    var progress: Float
    var isDone: Bool
    var isLoading: Bool
    
    init(theme: Theme, progress: Float, isDone: Bool, isLoading: Bool) {
        self.theme = theme
        self.progress = progress
        self.isDone = isDone
        self.isLoading = isLoading
    }
}
