//
//  ViewController.swift
//  Exhale-iOS
//
//  Created by Дмитрий Юдин on 17.03.2022.
//

import UIKit

class ViewController: UIViewController {
    
    let audioService = AudioService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioService.play(filename: "test", type: "mp3")
    }
}

