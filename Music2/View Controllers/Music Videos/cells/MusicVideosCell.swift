//
//  MusicVideosCell.swift
//  Music2
//
//  Created by Komal Kaur on 3/20/22.
//

import UIKit
import AVFoundation
import Parse

class MusicVideosCell: UITableViewCell {
    
    @IBOutlet weak var artistNameLabel: UILabel!
    
    @IBOutlet weak var albumNameandSongNameLabel: UILabel!
    
    @IBOutlet weak var musicVideoView: UIView!
    
    @IBOutlet weak var likeButton: UIButton!
    
    
    @IBOutlet weak var genreLabel: UILabel!
    
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var moreInfo: UILabel!
    
    @IBAction func onLike(_ sender: UIButton) {
        
        if isActive {
            isActive = false
            likeButton.tintColor = .systemPink
            
        }
        
        else {
            isActive = true
            likeButton.tintColor = .white
        }
        
    }
    
    
    
    
    @IBOutlet weak var commentButton: UIButton!
    
    
//MARK: GLOBAL VARS
    
    var avPlayer: AVPlayer?
    var avPlayerLayer: AVPlayerLayer?
    var paused: Bool = false
    var isActive: Bool = true //for like button
    
    
    //This will be called everytime a new value is set on the videoplayer item
       var videoPlayerItem: AVPlayerItem? = nil {
           didSet {
               /*
                If needed, configure player item here before associating it with a player.
                (example: adding outputs, setting text style rules, selecting media options)
                */
               avPlayer?.replaceCurrentItem(with: self.videoPlayerItem)
           }
       }

    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupMoviePlayer()
    }

    func setupMoviePlayer(){
            self.avPlayer = AVPlayer.init(playerItem: self.videoPlayerItem)
            avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
            avPlayer?.volume = 3
            avPlayer?.actionAtItemEnd = .none

            //        You need to have different variations
            //        according to the device so as the avplayer fits well
            if UIScreen.main.bounds.width == 375 {
                let widthRequired = self.frame.size.width - 20
                avPlayerLayer?.frame = CGRect.init(x: 0, y: 0, width: widthRequired, height: widthRequired/1.78)
            }else if UIScreen.main.bounds.width == 320 {
                avPlayerLayer?.frame = CGRect.init(x: 0, y: 0, width: (self.frame.size.height - 120) * 1.78, height: self.frame.size.height - 120)
            }else{
                let widthRequired = self.frame.size.width
                avPlayerLayer?.frame = CGRect.init(x: 0, y: 0, width: widthRequired, height: widthRequired/1.78)
            }
            self.backgroundColor = .clear
           self.musicVideoView.layer.insertSublayer(avPlayerLayer!, at: 0)

            // This notification is fired when the video ends, you can handle it in the method.
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.playerItemDidReachEnd(notification:)),
                                                   name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                   object: avPlayer?.currentItem)
        }
    
    func stopPlayback(){
            self.avPlayer?.pause()
        }

        func startPlayback(){
            self.avPlayer?.play()
        }

        // A notification is fired and seeker is sent to the beginning to loop the video again
    @objc func playerItemDidReachEnd(notification: Notification) {
            let p: AVPlayerItem = notification.object as! AVPlayerItem
            p.seek(to: CMTime.zero)
        }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
