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
    private var cellsData = mockThemes.map { ThemeDownloadCellModel(theme: $0, state: DownloadTaskState.none )}
    
    private lazy var downloader = Downloader(progressDelegate: self)
    
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
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: ThemeDownloadCell.identifier,
                                                     for: indexPath) as? ThemeDownloadCell
        else { return .init() }
        
        cell.configure(data: cellsData[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch cellsData[indexPath.row].state {
        case .none:
            downloader.download(from: cellsData[indexPath.row].theme.url, at: indexPath)
        case .loading(_):
            downloader.pause(at: indexPath)
        case .pause:
            downloader.resume(at: indexPath)
        default:
            break
        }
    }
}

extension ViewController: DownloadDelegate {
    func updateState(_ state: DownloadTaskState, at indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ThemeDownloadCell else { return }
        cell.updateState(state)
        let cellData = cellsData[indexPath.row]
        cellData.state = state

        switch state {
        case .loading(let progress):
            cellData.progress = progress
        case .cancel:
            cellData.progress = 0
        default:
            break
        }
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

