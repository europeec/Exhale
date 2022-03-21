import Foundation

protocol ThemeDownloadCellDelegate: AnyObject {
    func cell(at indexPath: IndexPath, didUpdateState state: DownloadTaskState)
}
