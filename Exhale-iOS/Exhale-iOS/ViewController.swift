//
//  ViewController.swift
//  Exhale-iOS
//
//  Created by Дмитрий Юдин on 17.03.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var progressBar: UIProgressView = {
        let progress = UIProgressView()
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(progressBar)
        
//        let url = URL(string: "https://rr4---sn-4g5ednz7.googlevideo.com/videoplayback?expire=1647640580&ei=pKs0Yt-oMIzyNsuwoYAP&ip=207.204.248.177&id=o-ANzyu51o5Tjgqz41FSHU2_X7N2hQPY0u-UxHOxvLPLDF&itag=22&source=youtube&requiressl=yes&vprv=1&mime=video%2Fmp4&ns=fZTRNzgxEhPdT9DcKDh22EEG&ratebypass=yes&dur=1411.262&lmt=1608571441415061&fexp=24001373,24007246&c=WEB&txp=6216222&n=7cMv79QbyFSXBw&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cvprv%2Cmime%2Cns%2Cratebypass%2Cdur%2Clmt&sig=AOq0QJ8wRQIhAJGGZIssx25zHIYT7OckcJZLjG1hoFNlJNhjzzT84NYqAiBpmSOppMt1y_0rPhoG8Xx-C4l-NtMxZCmlpLQNT8dJmQ%3D%3D&title=iOS%20Dev%2025%3A%20URLSession%20Download%20Task%20(Image%20Download%20with%20Progress%20Indicator)%20%7C%20Swift%205%2C%20XCode%2012&rm=sn-q4feey7l&req_id=a105aee8c0dfa3ee&ipbypass=yes&cm2rm=sn-c5niuxaxjvh-045l7d,sn-n8vy77d&redirect_counter=3&cms_redirect=yes&cmsv=e&mh=Jo&mip=93.120.147.170&mm=34&mn=sn-4g5ednz7&ms=ltu&mt=1647618107&mv=u&mvi=4&pl=23&lsparams=ipbypass,mh,mip,mm,mn,ms,mv,mvi,pl&lsig=AG3C_xAwRQIhALN90otdQnRpyTeXY6je6HYycoeFpjB-7Fx2bqKdBbTuAiBDWz7EW7GAFB4nqE6DejbsjRmxQDcG5_JlP27If3xdIQ%3D%3D")!
        let url = URL(string: "https://source.unsplash.com/random/4000x4000")!
        let downloader = Downloader(url: url, delegate: self)
        downloader.download()
//        print(url.hashValue)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        NSLayoutConstraint.activate([
            progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            progressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            progressBar.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension ViewController: DownloadDelegate {
    func updateState(_ state: DownloadTaskState, for taskURL: URL) {
        print(state)

        switch state {
        case .loading(let progress):
            progressBar.progress = progress
        case .pause:
            progressBar.progressTintColor = .cyan
        case .cancel, .starting:
            break
        case .done(let location):
            progressBar.progressTintColor = .green
        }
    }
}

