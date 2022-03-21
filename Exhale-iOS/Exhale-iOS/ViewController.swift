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
    private let themes = mockThemes
    
    private lazy var downloader = Downloader()
    
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
        themes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: ThemeDownloadCell.identifier,
                                                     for: indexPath) as? ThemeDownloadCell
        else { return .init() }
        
        cell.configure(theme: themes[indexPath.row], delegate: self, at: indexPath)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected: \(indexPath)")
        guard let cell = tableView.cellForRow(at: indexPath) as? ThemeDownloadCell else { return }
        
        if !cell.isDone {
            
        }
        
        if !cell.isLoading, !cell.isDone {
            downloader.download(from: themes[indexPath.row].url, progressDelegate: cell)
        }
        
        cell.select()
    }
}

extension ViewController: ThemeDownloadCellDelegate {
    func cell(at indexPath: IndexPath, didUpdateState state: DownloadTaskState) {
        print(indexPath, state)
        switch state {
        case .loading(let progress):
            print(progress)
        case .pause:
            let url = themes[indexPath.row].url
            downloader.pause(for: url)
        case .cancel:
            break
        case .starting:
            break
        case .done(let location):
            let url = themes[indexPath.row].url
            downloader.done(for: url)
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
                  Theme(name: "second", url: URL(string: "https://source.unsplash.com/random/11000x12000")!)]

