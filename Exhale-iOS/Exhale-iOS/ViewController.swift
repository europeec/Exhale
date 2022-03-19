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
    
    static let url = URL(string: "https://source.unsplash.com/random/4000x4000")!
    private let themes = [Theme].init(repeating: Theme(name: "Autoumb", url: url), count: 20)
    
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ThemeDownloadCell.identifier, for: indexPath) as? ThemeDownloadCell else { return .init() }
        
        cell.configure(theme: themes[indexPath.row])
        return cell
    }
}
