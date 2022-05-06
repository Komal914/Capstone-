//
//  songViewController.swift
//  Music2
//
//  Created by Sumiya Akter on 4/21/22.
//

import UIKit
import AVFoundation
import Parse

class songViewController: UIViewController {
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var songInfoLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var songImageView: UIImageView!
    //var selectedPost = [PFFileObject]()
    var avPlayer: AVPlayer?
    var videoPlayerItem: AVPlayerItem? = nil {
        didSet {
            avPlayer?.replaceCurrentItem(with: self.videoPlayerItem)
        }
    }
    var imageURLS = String()
    var songImage: UIImage!
    var songTitle = ""
    var lPosts = [PFObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MY URLS AS STRINGS: ", imageURLS)
        
        
        let url = URL(string: self.imageURLS)
        self.songImageView.af.setImage(withURL: url!)
        

        // Do any additional setup after loading the view.
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //MARK: GENRE STUFF
        let myBlue = UIColor(red: 62.0/255, green: 174.0/255, blue: 206.0/255, alpha: 1.0)
        let myGreen = UIColor(red: 110.0/255, green: 186.0/255, blue: 64.0/255, alpha: 1.0)
        let myRed = UIColor(red: 247.0/255, green: 118.0/255, blue: 113.0/255, alpha: 1.0)
        let myYellow = UIColor(red: 255.0/255, green: 190.0/255, blue: 106.0/255, alpha: 1.0)
        let hotpink = UIColor(red: 1.00, green: 0.00, blue: 0.82, alpha: 1.00)
        let yellowgreen = UIColor(red: 0.87, green: 1.00, blue: 0.00, alpha: 1.00)
        let lavender = UIColor(red: 0.87, green: 0.78, blue: 1.00, alpha: 1.00)
        let blue = UIColor(red: 0.66, green: 1.00, blue: 0.97, alpha: 1.00)
        let purple = UIColor(red: 0.50, green: 0.00, blue: 1.00, alpha: 1.00)
        let orange = UIColor(red: 1.00, green: 0.55, blue: 0.00, alpha: 1.00)
        let pink = UIColor(red: 1.00, green: 0.73, blue: 0.85, alpha: 1.00)
        
        let myColors = [myRed, myBlue, myGreen, myYellow, hotpink, yellowgreen, lavender, blue, purple, orange, pink]
        
        func random(colors: [UIColor]) -> UIColor {
            return colors[Int(arc4random_uniform(UInt32(myColors.count)))]
        }
        
        
        let query = PFQuery(className: "posts")
        
        query.includeKey("cover")
        query.findObjectsInBackground{(posts, error) in
            if posts != nil {
                self.lPosts = posts!
                for post in self.lPosts{
                    print("post: ", post)
                    let imageFile = post["cover"] as? PFFileObject
                    let fileString = imageFile?.url
                    if fileString == self.imageURLS
                    {
                        self.songInfoLabel.text = post["song"] as? String
                        
                        self.genreLabel.text = post["genre"] as? String
                        self.genreLabel.backgroundColor = random(colors: myColors)
                        self.genreLabel.layer.masksToBounds = true
                        self.genreLabel.layer.cornerRadius = 8
                        
                        self.artistLabel.text = post["artistName"] as? String
                        let sound = post["audio"] as! String
                        let soundURL = URL(string: sound)
                        self.videoPlayerItem = AVPlayerItem.init(url: soundURL!)
                    }
                    //print("here lies the image: ", imageFile)
                }
                //print("Here Lies All the POsts: ", self.lPosts)
                
            }
        }
        updateValues()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setUpPlayer()
    }
    
    func updateValues ()
    {
        print("Round TWO: ", lPosts)
    }
    
    func setUpPlayer(){
        self.avPlayer = AVPlayer.init(playerItem: self.videoPlayerItem)
        avPlayer?.volume = 3
        avPlayer?.actionAtItemEnd = .none
    }
    
    @IBAction func onPlayButton(_ sender: Any) {
        startPlayback()
    }
    
    @IBAction func onPauseButton(_ sender: Any) {
        stopPlayback()
    }
    
    func stopPlayback(){
        self.avPlayer?.pause()
    }
    
    func startPlayback(){
        self.avPlayer?.play()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
