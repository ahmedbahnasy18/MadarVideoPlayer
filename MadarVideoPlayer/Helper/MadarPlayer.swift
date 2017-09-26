//
//  MadarPlayer.swift
//  MadarVideoPlayer
//
//  Created by Ahmed on 9/26/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import UIKit

class MadarPlayer: NSObject {
    static var youtubePlayer = YTPlayerView()
    
    class func showVideoPlayer(myView: UIView, videoId: String) {
        
        youtubePlayer.frame = CGRect(x: 0, y: 0, width: myView.frame.width, height: myView.frame.height)
        youtubePlayer.backgroundColor = UIColor.black
        youtubePlayer.load(withVideoId: videoId, playerVars: ["playsinline" : 1, "autoplay" : 1])
        myView.addSubview(youtubePlayer)
    }
}
