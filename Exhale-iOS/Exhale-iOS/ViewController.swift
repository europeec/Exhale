//
//  ViewController.swift
//  Exhale-iOS
//
//  Created by Дмитрий Юдин on 17.03.2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let cache = ThemeCache()
        
        cache.store(filename: "filename", item: Theme(name: "Test Theme"))
    }


}

