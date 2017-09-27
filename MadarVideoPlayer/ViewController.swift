//
//  ViewController.swift
//  MadarVideoPlayer
//
//  Created by Ahmed on 9/26/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    fileprivate let cellIdentifier = "VideoCell"
    var adView: UIView!
    var videosArr = ["aDol6BM3ho8", "MozlO_atgro", "9dbWsUBgLfU", "SMlnc3sR8SA", "EcXeJOHkmgo"]
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        MadarPlayer.youtubePlayer.delegate = self
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videosArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? VideoCell else {
            return UITableViewCell()
        }
        cell.configureCell(videoId: videosArr[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

extension ViewController: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        MadarPlayer.youtubePlayer.playVideo()
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        switch state {
        case YTPlayerState.ended:
            MadarPlayer.youtubePlayer.removeFromSuperview()
            break
        default:
            break
        }
    }
    
    func playerView(_ playerView: YTPlayerView, didPlayTime playTime: Float) {
        
        let isFullscreenMode = AppDelegate.shared().isFullscreenMode
        let fullscreenVc = AppDelegate.shared().fullscreenVC
        
        let videoDuration = MadarPlayer.youtubePlayer.duration()
        
        if isFullscreenMode && !AppDelegate.shared().adDisplayed && Int(playTime) == Int(videoDuration/20) {
            
            let fullOverlay: UIView = {
                let view = UIView()
                view.backgroundColor = UIColor.green
                return view
            }()
            fullOverlay.frame.size.height = ((fullscreenVc.view.frame.size.height)/2)
            fullOverlay.frame.size.width = ((fullscreenVc.view.frame.size.width)/2)
            fullscreenVc.view.addSubview(fullOverlay)
            MadarPlayer.youtubePlayer.pauseVideo()
            
            AppDelegate.shared().adDisplayed = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                fullOverlay.removeFromSuperview()
                MadarPlayer.youtubePlayer.playVideo()
            }
            
        } else if !isFullscreenMode && !AppDelegate.shared().adDisplayed && Int(playTime) == Int(videoDuration/20) {
            
            let inlineOverlay: UIView = {
                let view = UIView()
                view.backgroundColor = UIColor.green
                return view
            }()
            self.adView = inlineOverlay
            let removeOverlayButton: UIButton = {
                let button = UIButton(type: .custom)
                let image = UIImage(named: "cancel")
                button.setImage(image, for: .normal)
                button.translatesAutoresizingMaskIntoConstraints = false
                button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
                return button
            }()
            
            inlineOverlay.frame = MadarPlayer.youtubePlayer.frame
            MadarPlayer.youtubePlayer.addSubview(inlineOverlay)
            MadarPlayer.youtubePlayer.pauseVideo()
            inlineOverlay.addSubview(removeOverlayButton)
            NSLayoutConstraint.activate([
                removeOverlayButton.rightAnchor.constraint(equalTo: inlineOverlay.rightAnchor, constant: -4),
                removeOverlayButton.topAnchor.constraint(equalTo: inlineOverlay.topAnchor, constant: 4),
                removeOverlayButton.heightAnchor.constraint(equalToConstant: 30),
                removeOverlayButton.widthAnchor.constraint(equalToConstant: 30)
                ])
            AppDelegate.shared().adDisplayed = true
        }
    }
    func handleClose() {
        self.adView.removeFromSuperview()
        MadarPlayer.youtubePlayer.playVideo()
    }
}
