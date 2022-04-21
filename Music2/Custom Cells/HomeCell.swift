//
//  HomeCell.swift
//  Music2
//
//  Created by Komal Kaur on 3/20/22.
//

import UIKit
import Parse
import AVFoundation

class HomeCell: UITableViewCell {
    
    //MARK: GLOBAL VARS
        
    var avPlayer: AVPlayer?
    var isActive: Bool = true
    
    
    @IBOutlet weak var genreLabel: UILabel!
    
    

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
    
    func setUpPlayer(){
            self.avPlayer = AVPlayer.init(playerItem: self.videoPlayerItem)
                       avPlayer?.volume = 3
            avPlayer?.actionAtItemEnd = .none
            
        }


    
    
    
    
    //MARK: Outlets
    
    @IBOutlet weak var albumNameSongName: UILabel!
    @IBOutlet weak var albumCover: UIImageView!
   
    @IBOutlet weak var artistNameLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    
 
    
    
    @IBAction func onLike(_ sender: UIButton) {
        let homeLikes = PFObject(className: "homeLikes")
        if isActive {
            isActive = false
            likeButton.tintColor = .systemPink
            homeLikes["author"] = PFUser.current()
            homeLikes["appleID"] = PFUser.current()?.username
            homeLikes["username"] = " "
            
            homeLikes["genre"] = self.genreLabel.text
           
            homeLikes["artistName"] = self.artistNameLabel.text
            
            homeLikes.saveInBackground { (succeeded, error)  in
                if (succeeded) {
                    // The object has been saved.
                  print("home like saved!")
                } else {
                   // print("error on saving data: \(error?.localizedDescription)")
                }
            }
        }
        
        else {
            isActive = true
            likeButton.tintColor = .white
            homeLikes.deleteEventually()
//            homeLikes.deleteInBackground() { (success, error) in
//                if success{
//                    print("deleted")
//                }
//                else{
//                    print("not deleted ")
//                }
//            }
            
        }
        

    }
    
    
    
   
    
    
    
    @IBAction func onPlay(_ sender: Any) {
        startPlayback()
    }
    
    
    
    @IBAction func onPause(_ sender: Any) {
       stopPlayback()
    }
    
    
    
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var captionFromTheUser: UILabel!
    
    
 
    
    
    @IBAction func commentButton(_ sender: Any) {
    }
    
    

    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setUpPlayer()
        
    }
    
    func stopPlayback(){
            self.avPlayer?.pause()
        }

        func startPlayback(){
            self.avPlayer?.play()
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
