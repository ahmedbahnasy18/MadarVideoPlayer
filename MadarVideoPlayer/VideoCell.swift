//
//  VideoCell.swift
//  MyVideoPlayer
//
//  Created by Ahmed on 8/23/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import UIKit

class VideoCell: UITableViewCell {

    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var coverButton: UIButton!
    @IBAction func videoLauncherBtnPressed(_ sender: UIButton) {
        AppDelegate.shared().adDisplayed = false
        AppDelegate.shared().isFullscreenMode = false
        MadarPlayer.showVideoPlayer(myView: coverButton, videoId: self.videoId)
    }
    var videoId: String!
    func configureCell(videoId: String) {
        self.videoId = videoId
    }
}
