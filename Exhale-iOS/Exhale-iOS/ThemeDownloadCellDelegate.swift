import Foundation

protocol ThemeDownloadCellDelegate {
    func cell(at indexPath: IndexPath, didUpdateState state: DownloadTaskState)
}
