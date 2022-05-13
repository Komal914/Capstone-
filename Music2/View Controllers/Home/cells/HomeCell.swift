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
    var homeLikes = [PFObject]()
    var objID = String()
    var userID = String()
    
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
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var captionFromTheUser: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    
    @IBAction func onLike(_ sender: UIButton) {
        //creating a new object here to save in my backend
        let homeLikes = PFObject(className: "homeLikes")
        print("homelikes", homeLikes)
        if isActive {
            isActive = false
            likeButton.tintColor = .systemPink
            
            homeLikes["author"] = PFUser.current()
            homeLikes["appleID"] = PFUser.current()?.username
            homeLikes["username"] = " "
            homeLikes["genre"] = self.genreLabel.text
            homeLikes["artistName"] = self.artistNameLabel.text

            homeLikes.saveInBackground { (succeeded, error) in
                if (succeeded) {
                    // The object has been saved
                    print("home like saved!")
                    self.objID = homeLikes.objectId!
                    print(self.objID)
                }
                
                else {
                   // print("error on saving data: \(error?.localizedDescription)")
                }
            }
        }
        
        else {
            isActive = true
            likeButton.tintColor = .white
            
            //print(self.objID)
            let query = PFQuery(className: "homeLikes")
            query.whereKey("appleID", equalTo: userID)
            
            query.findObjectsInBackground{(like, error) in
                if like != nil{
                    self.homeLikes = like! //storing from backend to this file
                    for like in self.homeLikes {
                        if (like.objectId == self.objID) {
                            like.deleteInBackground{(success, error) in
                                if (success) {
                                    // The object has been saved
                                    print("deleted")
                                }
                            }
                        }
                    }
                }
                
                else {
                    print("error quering for posts: \(String(describing: error))")
                }
            }
        }
    }
    
    @IBAction func onPlay(_ sender: Any) {
        startPlayback()
    }
    
    @IBAction func onPause(_ sender: Any) {
       stopPlayback()
    }
    
    @IBAction func commentButton(_ sender: Any) {
    
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setUpPlayer()
        let query = PFQuery(className: "profileInfo")   //search this class
        let user = PFUser.current()
        self.userID = user!["username"] as! String
        query.whereKey("appleID", equalTo: userID)      //search by current user
    }
    
    func stopPlayback(){
        self.avPlayer?.pause()
    }

    func startPlayback(){
        self.avPlayer?.play()
    }
}
