//
//  MusicVideosViewController.swift
//  Music2
//
//  Created by Komal Kaur on 3/20/22.
//

import UIKit
import StoreKit
import MediaPlayer
import AVFoundation


class MusicVideosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var player : AVPlayer!
    var avPlayerLayer : AVPlayerLayer!
  
    var videoData = [[String: Any?]]() //array of dictionaries
    var filteredVideoData = [[String: Any?]]()
    
//MARK: OUTLETS
        
    @IBOutlet weak var table: UITableView!

    
//MARK: VIEWDIDLOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        table.delegate = self
        table.dataSource = self
   
//MARK: Storefront
        
        // store front
        let controller = SKCloudServiceController()
        controller.requestStorefrontCountryCode { countryCode, error in
            
            // Use the value in countryCode for subsequent API requests
            if #available(iOS 15.0, *) {
                print("Storyboard:", Storefront.self)
                print(countryCode)
            }
            
            else {
                // Fallback on earlier versions
                print("NO storefront")
            }
        }

// MARK: API REQUEST
        
        let developerToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiIsImtpZCI6IjQ1OVlDU0NWN04ifQ.eyJpc3MiOiI0VlMzWEFQWFRWIiwiZXhwIjoxNjYzNTcyNzMzLCJpYXQiOjE2NDc4MDQ3MzN9.J-jb_NnC82o7oSlFvLt84mf7AkNJ3o8Fhhld4ADIDmgY6NfUBVprpD7y1yqX3pjtIUFI85RDxE2yKS12TFmVuA"
        
        //let baseAPIUrl = "https://api.music.apple.com/v1/catalog/"
        //let base2Url = baseUrl + Storefront
        
        let url = URL(string:"https://api.music.apple.com/v1/catalog/us/music-videos?ids=1553279848,1549013065")!

        var request = URLRequest(url: url)
        request.setValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")

        let session = URLSession.shared

  
        let task = session.dataTask(with: request) {(data, response, error) in
            guard let data = data else {
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                self.videoData = json?["data"] as! [[String: Any]]
                // print("got the goods")
                
                DispatchQueue.main.async {
                    self.table.reloadData()
                    //  print("reloaded")
                }
                
                //self.filteredVideoData = self.videoData.flatMap { $0 }
                //print("Json Below:")
                //print(videoData)
                //print("inside the do")
            }
            
            catch {
            }
        }
        task.resume()
        
        // print("after task")
        // Do any additional setup after loading the view.
        
        table.reloadData()
    }
    

//MARK: TABLE FUNCTIONS
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 700//or whatever you need
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        //should return .count of the number of music videos
        return videoData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "MusicVideosCell") as! MusicVideosCell
        
                
        let video = videoData[indexPath.row] as! NSDictionary //each video data
        let attributes = video["attributes"] as! NSDictionary //attributes for each video
        let name = attributes["name"] as! String
        let previews = attributes["previews"] as! NSArray
        let artwork = previews[0] as! NSDictionary
        let musicVideoUrl = artwork["url"] as! String
        print(musicVideoUrl)
        let artistName = attributes["artistName"] as! String
        cell.artistNameLabel!.text = artistName
        cell.albumNameandSongNameLabel!.text = name
        
        
        let videoURL = NSURL(string: musicVideoUrl)
        
        
        let avPlayer = AVPlayer(url: videoURL! as URL)
        
        cell.musicVideoView?.playerLayer.player = avPlayer
        
        //if the scroll view has the content to its top -> then play the vid
        //right now all vids are playing, so i need a case statement here
        
        cell.musicVideoView.player?.play()
        
        
//        let player = AVPlayer(url: videoURL!)
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = self.view.bounds
//        self.view.layer.addSublayer(playerLayer)
//        player.play()
        
        return cell
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
