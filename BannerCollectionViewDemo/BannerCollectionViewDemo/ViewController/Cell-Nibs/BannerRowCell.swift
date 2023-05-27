//
//  BannerRowCell.swift
//  BannerCollectionViewDemo
//
//  Created by Zignuts Technolab on 18/05/23.
//

import UIKit
import AVKit
import SDWebImage
import AVFoundation
import ASPVideoPlayer

class BannerRowCell: UICollectionViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var activityIndi: UIActivityIndicatorView!
    @IBOutlet weak var view_videoPlayer: ASPVideoPlayerView!
    @IBOutlet weak var imgView: SDAnimatedImageView!
   
    // MARK: - Local var
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.view_videoPlayer.volume = 1.0
        self.view_videoPlayer.gravity = .aspectFill
        self.view_videoPlayer.shouldLoop = true
        self.view_videoPlayer.startPlayingWhenReady = true
    }
    
    func configure(with url: URL) {
        
        let fileExtension = url.pathExtension.lowercased()
        self.activityIndi.startAnimating()
        self.view_videoPlayer.videoURL = url
        self.activityIndi.isHidden = false
        
        if fileExtension == "mp4"{
            self.imgView.isHidden = true
            self.view_videoPlayer.isHidden = false
            self.videStatus()
        } else {
            self.imgView.isHidden = false
            self.view_videoPlayer.isHidden = true
            self.imgView.sd_setImage(with: url, placeholderImage: nil, options: .highPriority, progress: nil) { (image, error, cacheType, url) in
                if error != nil { return}
                // Stop the activity indicator animation
                self.activityIndi.stopAnimating()
                self.activityIndi.isHidden = true
            }
        }
    }
    
    func playVideo() {
        self.view_videoPlayer.playVideo()
    }
    
    func pauseVideo() {
        self.view_videoPlayer.pauseVideo()
    }
    
    func videStatus() {
        
        self.view_videoPlayer.newVideo = {
            print("newVideo")
        }
        
        self.view_videoPlayer.readyToPlayVideo = {
            print("readyToPlay")
        }
        
        self.view_videoPlayer.startedVideo = {
            print("start")
        }
        
        self.view_videoPlayer.finishedVideo = { [weak self] in
            guard let _ = self else { return }
            print("finishedVideo")
        }
        
        self.view_videoPlayer.playingVideo = { (progress) -> Void in
            let progressString = String.localizedStringWithFormat("%.2f", progress)
            print("progress: \(progressString) % complete.")
            self.activityIndi.isHidden = true
            self.activityIndi.stopAnimating()
        }
        
        self.view_videoPlayer.pausedVideo = {
            print("paused")
        }
        
        self.view_videoPlayer.stoppedVideo = {
            print("stopped")
        }
        
        self.view_videoPlayer.error = { (error) -> Void in
            print("Error: \(error.localizedDescription)")
        }
    }
}
