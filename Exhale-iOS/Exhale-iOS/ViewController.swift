//
//  ViewController.swift
//  Exhale-iOS
//
//  Created by Дмитрий Юдин on 17.03.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ThemeDownloadCell.self, forCellReuseIdentifier: ThemeDownloadCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    static let url = URL(string: "https://source.unsplash.com/random/8000x8000")!
    private var cellsData = mockThemes.map { ThemeDownloadCellModel(theme: $0, progress: 0, isDone: false, isLoading: false)}
    private var indexPaths = [URL: IndexPath]()
    
    private lazy var downloader = Downloader(progressDelegate: self)
    private var activeDownloadCell = [IndexPath: ThemeDownloadCell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = activeDownloadCell[indexPath] {
            return cell
        } else {
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: ThemeDownloadCell.identifier,
                                                         for: indexPath) as? ThemeDownloadCell
            else { return .init() }
            
            cell.configure(data: cellsData[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected: \(indexPath)")
        
        let cellData = cellsData[indexPath.row]
        let url = cellData.theme.url
        if !cellData.isDone {
            guard let cell = tableView.cellForRow(at: indexPath) as? ThemeDownloadCell else { return }
            if indexPaths[cellData.theme.url] != nil {
                if cellsData[indexPath.row].isLoading {
                    downloader.pause(for: url)
                    cell.updateState(.pause)
                    cellData.isLoading = false
                } else {
                    cellData.isLoading = true
                    downloader.resume(for: url)
                }
            } else {
                indexPaths[url] = indexPath
                downloader.download(from: url)
                cellData.isLoading = true
                cell.updateState(.starting)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print(activeDownloadCell)
    }
}

extension ViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        guard let url = downloadTask.originalRequest?.url else { return }
        
        downloader.done(for: url)
        
        if let indexPath = indexPaths[url] {
            let cellData = cellsData[indexPath.row]
            cellData.isDone = true
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {

        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        print(progress)
        
        guard let url = downloadTask.originalRequest?.url,
              let indexPath = indexPaths[url]
        else { return }
        
        guard let cell = tableView.cellForRow(at: indexPath) as? ThemeDownloadCell else { return }
        
        cell.updateState(.loading(progress: progress))
        cellsData[indexPath.row].progress = progress
            
        }
}

let mockThemes = [Theme(name: "First", url: URL(string: "https://source.unsplash.com/random/8000x8000")!),
                  Theme(name: "second", url: URL(string: "https://source.unsplash.com/random/12000x12000")!),
                  Theme(name: "First", url: URL(string: "https://source.unsplash.com/random/11000x11000")!),
                  Theme(name: "second", url: URL(string: "https://source.unsplash.com/random/9000x12000")!),
                  Theme(name: "First", url: URL(string: "https://source.unsplash.com/random/12000x8000")!),
                  Theme(name: "second", url: URL(string: "https://source.unsplash.com/random/12000x13000")!),
                  Theme(name: "First", url: URL(string: "https://source.unsplash.com/random/7000x8000")!),
                  Theme(name: "second", url: URL(string: "https://source.unsplash.com/random/11000x12000")!),
                  Theme(name: "First", url: URL(string: "https://source.unsplash.com/random/81000x8000")!),
                  Theme(name: "second", url: URL(string: "https://source.unsplash.com/random/112000x12000")!),
                  Theme(name: "First", url: URL(string: "https://source.unsplash.com/random/11000x11000")!),
                  Theme(name: "second", url: URL(string: "https://source.unsplash.com/random/19000x12000")!),
                  Theme(name: "First", url: URL(string: "https://source.unsplash.com/random/112000x8000")!),
                  Theme(name: "second", url: URL(string: "https://source.unsplash.com/random/121000x13000")!),
                  Theme(name: "First", url: URL(string: "https://source.unsplash.com/random/70100x8000")!),
                  Theme(name: "second", url: URL(string: "https://source.unsplash.com/random/111000x12000")!),
                  Theme(name: "First", url: URL(string: "https://source.unsplash.com/random/80100x8000")!),
                  Theme(name: "second", url: URL(string: "https://source.unsplash.com/random/121000x12000")!),
                  Theme(name: "First", url: URL(string: "https://source.unsplash.com/random/110100x11000")!),
                  Theme(name: "second", url: URL(string: "https://source.unsplash.com/random/90100x12000")!),
                  Theme(name: "First", url: URL(string: "https://source.unsplash.com/random/120001x8000")!),
                  Theme(name: "second", url: URL(string: "https://source.unsplash.com/random/120001x13000")!),
                  Theme(name: "First", url: URL(string: "https://source.unsplash.com/random/7000x80010")!),
                  Theme(name: "second", url: URL(string: "https://source.unsplash.com/random/11000x120100")!),
                  Theme(name: "First", url: URL(string: "https://source.unsplash.com/random/8000x8000")!),
                  Theme(name: "second", url: URL(string: "https://source.unsplash.com/random/12000x121000")!),
                  Theme(name: "First", url: URL(string: "https://source.unsplash.com/random/11000x11000")!),
                  Theme(name: "second", url: URL(string: "https://source.unsplash.com/random/9000x120100")!),
                  Theme(name: "First", url: URL(string: "https://source.unsplash.com/random/120100x8000")!),
                  Theme(name: "second", url: URL(string: "https://source.unsplash.com/random/12000x130001")!),
                  Theme(name: "First", url: URL(string: "https://source.unsplash.com/random/7000x80001")!),
                  Theme(name: "second", url: URL(string: "https://source.unsplash.com/random/11000x121000")!),
                  Theme(name: "First", url: URL(string: "https://source.unsplash.com/random/80100x8000")!),
                  Theme(name: "second", url: URL(string: "https://source.unsplash.com/random/121000x12000")!),
                  Theme(name: "First", url: URL(string: "https://source.unsplash.com/random/11000x110010")!),
                  Theme(name: "second", url: URL(string: "https://source.unsplash.com/random/90100x12000")!),
                  Theme(name: "First", url: URL(string: "https://source.unsplash.com/random/12000x80010")!),
                  Theme(name: "second", url: URL(string: "https://source.unsplash.com/random/120100x13000")!),
                  Theme(name: "First", url: URL(string: "https://source.unsplash.com/random/7000x80100")!),
                  Theme(name: "second", url: URL(string: "https://source.unsplash.com/random/110100x12000")!),
                  Theme(name: "First", url: URL(string: "https://source.unsplash.com/random/8000x80100")!),
                  Theme(name: "second", url: URL(string: "https://source.unsplash.com/random/120010x12000")!),
                  Theme(name: "First", url: URL(string: "https://source.unsplash.com/random/11000x110100")!),
                  Theme(name: "second", url: URL(string: "https://source.unsplash.com/random/90100x12000")!),
                  Theme(name: "First", url: URL(string: "https://source.unsplash.com/random/12000x80010")!),
                  Theme(name: "second", url: URL(string: "https://source.unsplash.com/random/120100x13000")!),
                  Theme(name: "First", url: URL(string: "https://source.unsplash.com/random/7000x80100")!),
                  Theme(name: "second", url: URL(string: "https://source.unsplash.com/random/110100x12000")!)]

