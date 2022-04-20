//
//  HomeViewController.swift
//  Music2
//
//  Created by Komal Kaur on 3/20/22.
//

import UIKit
import Parse
import AVFoundation

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    var user: User?
    var posts = [PFObject]()
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //print("hello")
        let query = PFQuery(className: "posts")
        query.findObjectsInBackground{(posts, error) in
            if posts != nil{
                self.posts = posts! //storing from backend to this file
                self.table.reloadData()
                //print(self.posts)
            }
            else {
                print("error quering for posts: \(String(describing: error))")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationItem.title = "Home"
        self.navigationController?.navigationBar.isHidden = true
        
        table.delegate = self
        table.dataSource = self
        
        //print(user?.debugDescription ?? "")
        //print("Print statement for ID: ", user?.id ?? "default")

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //should return number of posts
        return posts.count
    }
    
    @IBAction func homeCommentButton(_ sender: Any) {
        performSegue(withIdentifier: "homeCommentSegue", sender: self)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 672 //or whatever you need
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = table.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeCell
        
        var reversePosts = [PFObject]()
        reversePosts = posts.reversed()
        //print("reversed:", reversePosts)
        let post = reversePosts[indexPath.row]
        
        //songinfo
        cell.albumNameSongName.text = post["song"] as? String
        
        //song cover
        let imageFile = post["cover"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        cell.albumCover.af.setImage(withURL: url)
        
        //caption
        let caption = post["caption"] as! String
        cell.captionFromTheUser.text = caption
        
        //artist name
        cell.artistNameLabel.text = post["artistName"] as? String
        
        //genres
        cell.genreLabel.text = post["genre"] as? String
        cell.genreLabel.layer.masksToBounds = true
        cell.genreLabel.layer.cornerRadius = 8
        
        
        //sound file
        let sound = post["audio"] as! String
        let soundUrl = URL(string: sound)
        //sendng music url to cell class
        cell.videoPlayerItem = AVPlayerItem.init(url: soundUrl!)
        
        
        //like button
        //cell.likeButton.setImage(UIImage(systemName: "search"), for: .normal)
    
            
       
       
        
        return cell
    }
}