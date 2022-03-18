import Foundation

protocol CacheProtocol {
    associatedtype Item

    func store(filename: String, item: Item)
    func fetch(filename: String) -> Item?
}

final class ThemeCache: CacheProtocol {
    typealias Item = Theme

    private let fileManager = FileManager.default
    private lazy var cachesPathURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
    
    func store(filename: String, item: Theme) {
        guard
            let themeFolderPath = cachesPathURL?.appendingPathComponent("/\(item.name)").path
        else { return }
        
        do {
            if !fileManager.fileExists(atPath: themeFolderPath) {
                try fileManager.createDirectory(atPath: themeFolderPath, withIntermediateDirectories: true)
            }
            
//        fileManager.createFile(atPath: folderPath.path, contents: data)

        } catch let error {
            #if DEBUG
            fatalError(error.localizedDescription)
            #endif
        }
    }
    
    func fetch(filename: String) -> Theme? {
        guard let themeFolderPath = cachesPathURL?.appendingPathComponent("/\(filename)") else {
            return nil
        }
        
        // TODO
        return nil
    }
}

// MOCK
struct Theme {
    let name: String
    
}
