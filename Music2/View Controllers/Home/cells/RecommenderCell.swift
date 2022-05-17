//
//  ReccomenderCell.swift
//  Music2
//
//  Created by Amogh Kalyan on 5/12/22.
//

import UIKit
import AVFoundation

class RecommenderCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpPlayer()
    }
    
    var avPlayer: AVPlayer?
    @IBOutlet var songLabel: UILabel!
    @IBOutlet var albumView: UIImageView!
    @IBOutlet var artistLabel: UILabel!
    
    var videoPlayerItem: AVPlayerItem? = nil {
        didSet {
            /*
             If needed, configure player item here before associating it with a player.
             (example: adding outputs, setting text style rules, selecting media options)
             */
            avPlayer?.replaceCurrentItem(with: self.videoPlayerItem)
        }
    }
     
     func setUpPlayer(){
         self.avPlayer = AVPlayer.init(playerItem: self.videoPlayerItem)
                        avPlayer?.volume = 3
         avPlayer?.actionAtItemEnd = .none
     }
    
    
    @IBAction func pauseButton(_ sender: Any) {
        stopPlayback()
    }
    
    @IBAction func playButton(_ sender: Any) {
        startPlayback()
    }
    
    func stopPlayback(){
        self.avPlayer?.pause()
    }

    func startPlayback(){
        self.avPlayer?.play()
    }
}
