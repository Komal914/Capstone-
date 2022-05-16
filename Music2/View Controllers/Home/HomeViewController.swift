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
    var username = String()
    var likedGenres = [String]()
    var randomGenre = String()
    var aboutToBecomeInvisibleCell = -1
    var visibleIP : IndexPath?
    var currentPostUsername = String()
    var currentSong = String()
    var recommendData = NSDictionary()
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBar.isHidden = true
        table.delegate = self
        table.dataSource = self
   
        // Do any additional setup after loading the view.
        
        visibleIP = IndexPath.init(row: 0, section: 0)
        
        let currentUser = PFUser.current()
        let userQuery = PFQuery(className: "profileInfo")
        let userID = currentUser!["username"] as! String
        userQuery.whereKey("appleID", equalTo: userID)
        userQuery.findObjectsInBackground{(profileInfo, error) in
            if profileInfo != nil {
                let first = profileInfo![0]
                self.username = first["username"] as! String
                //print("query user", self.username)
            }
        }

        // query for likedGenres
        let genreQuery = PFQuery(className: "likedGenres")
        genreQuery.whereKey("username", equalTo: userID)
        genreQuery.findObjectsInBackground{(genres, error) in
            if genres != nil {
                let temp = genres![0]
                self.likedGenres = temp["genre"] as! [String]
                print(self.likedGenres)
                self.randomGenre = self.likedGenres.randomElement()!
                print("oh my lord",self.randomGenre)
                
                /*let developerToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiIsImtpZCI6IjQ1OVlDU0NWN04ifQ.eyJpc3MiOiI0VlMzWEFQWFRWIiwiZXhwIjoxNjYzNTcyNzMzLCJpYXQiOjE2NDc4MDQ3MzN9.J-jb_NnC82o7oSlFvLt84mf7AkNJ3o8Fhhld4ADIDmgY6NfUBVprpD7y1yqX3pjtIUFI85RDxE2yKS12TFmVuA"
                
              let base = "https://api.music.apple.com/v1/catalog/us/search?types=songs&term="
                let end = self.randomGenre
                let final = base + end
                let url = URL(string:final)!
                        var request = URLRequest(url: url)
                        request.setValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")
                        let session = URLSession.shared
                        //print("Starting task")
                        let task = session.dataTask(with: request) { data, response, error in
                            guard let data = data else {
                                return
                            }
                            
                            do {
                                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                                let results = json!["results"] as! NSDictionary
                                //print(results)
                                let songs = results["songs"] as! NSDictionary
                                let data = songs["data"] as! NSArray
                                let attribute = data[0] as! NSDictionary
                                let songInfo = attribute["attributes"] as! NSDictionary
                                self.recommendData = songInfo
                                let albumName = songInfo["albumName"] as! String
                                //print(albumName)
                            }
                            
                            catch {
                                
                            }
                        }
                        task.resume()*/
            }
        }
        
        //print("oh my",self.randomGenre)
        
//        let developerToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiIsImtpZCI6IjQ1OVlDU0NWN04ifQ.eyJpc3MiOiI0VlMzWEFQWFRWIiwiZXhwIjoxNjYzNTcyNzMzLCJpYXQiOjE2NDc4MDQ3MzN9.J-jb_NnC82o7oSlFvLt84mf7AkNJ3o8Fhhld4ADIDmgY6NfUBVprpD7y1yqX3pjtIUFI85RDxE2yKS12TFmVuA"
//
//        print("load ", self.likedGenres)
//        let url = URL(string:"https://api.music.apple.com/v1/catalog/us/search?types=songs&term=Hip+Hop")!
//                var request = URLRequest(url: url)
//                request.setValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")
//                let session = URLSession.shared
//                //print("Starting task")
//                let task = session.dataTask(with: request) { data, response, error in
//                    guard let data = data else {
//                        return
//                    }
//
//                    do {
//                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//                        let results = json!["results"] as! NSDictionary
//                        print(results)
//                        let songs = results["songs"] as! NSDictionary
//                        let data = songs["data"] as! NSArray
//                        let attribute = data[0] as! NSDictionary
//                        let songInfo = attribute["attributes"] as! NSDictionary
//                        let albumName = songInfo["albumName"] as! String
//                        print(albumName)
//                    }
//
//                    catch {
//
//                    }
//                }
//                task.resume()
        
        //createRandomGenre()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //MARK: PARSE: Queries to backend
        let query = PFQuery(className: "posts")
        query.findObjectsInBackground{(posts, error) in
            if posts != nil{
                self.posts = posts!                     //storing from backend to this file
                var reversePosts = [PFObject]()
                reversePosts = posts!.reversed()
                let first = reversePosts[0]
                self.currentPostUsername = first["username"] as! String
                self.table.reloadData()
            }
            
            else {
                print("error quering for posts: \(String(describing: error))")
            }
        }
        print("I AM HERE")
        
       
        
    
    
        
        
    }
    /*
    // fetches random genre
    func createRandomGenre() {
        // checks if genre list is NOT empty
        if likedGenres.isEmpty == false {
            randomGenre = likedGenres.randomElement()!
            print(randomGenre)
        }
    }*/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //should return number of posts
        return posts.count
    }
    
    @IBAction func homeCommentButton(_ sender: Any) {
        performSegue(withIdentifier: "homeComment", sender: self)
    }
    
        
    @IBAction func onUsernameButton(_ sender: UIButton) {
        performSegue(withIdentifier: "userProfile", sender: self)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("HAIIIIII",self.recommendData)
        let indexPaths = self.table.indexPathsForVisibleRows
        var cells = [Any]()
        for ip in indexPaths!{
            if let HomeCell = self.table.cellForRow(at: ip) as? HomeCell{
                cells.append(HomeCell)
            }
        }
    
        let cellCount = cells.count
        
        if cellCount == 0 {
            return
        }
        
        if cellCount == 1 {
            if visibleIP != indexPaths?[0]{
                visibleIP = indexPaths?[0]
            }
            
            if let homeCell = cells.last! as? HomeCell{
                currentPostUsername = self.getUserName(cell: homeCell, indexPath: (indexPaths?.last)!)
                currentSong = self.getcurrentSong(cell: homeCell, indexPath: (indexPaths?.last)!)

                //print("POST 0",currentPostUsername)
                //print("POST 0", currentSong)

            }
        }
    
        if cellCount >= 2 {
            for i in 0..<cellCount {
                let cellRect = self.table.rectForRow(at: (indexPaths?[i])!)
                let intersect = cellRect.intersection(self.table.bounds)

                // curerntHeight is the height of the cell that is visible
                let currentHeight = intersect.height
                //print("\n \(currentHeight)")
                let cellHeight = (cells[i] as AnyObject).frame.size.height
                
                // 0.95 here denotes how much you want the cell to display for it to mark itself as visible, .95 denotes 95 percent, you can change the values accordingly
                if currentHeight > (cellHeight * 0.95){
                    if visibleIP != indexPaths?[i]{
                        visibleIP = indexPaths?[i]
                        //print ("visible = \(indexPaths?[i])")
                        if let homeCell = cells[i] as? HomeCell{
                            currentPostUsername = self.getUserName(cell: homeCell, indexPath: (indexPaths?[i])!)
                            currentSong = self.getcurrentSong(cell: homeCell, indexPath: (indexPaths?[i])!)

                            //print("USERNAMEEEE ", currentPostUsername)
                            //print("SONGGG ", currentSong)
                        }
                    }
                }
            }
        }
    }
    
    func getcurrentSong(cell: HomeCell, indexPath: IndexPath) -> String{
        return cell.albumNameSongName.text!
    }
    
    func getUserName(cell : HomeCell, indexPath : IndexPath) -> String{
        return cell.usernameButton.currentTitle!
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 672          //or whatever you need
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = table.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeCell
        let recommenderCell = table.dequeueReusableCell(withIdentifier: "RecommenderCell") as! RecommenderCell
        
        var reversePosts = [PFObject]()
        reversePosts = posts.reversed()
        
        let post = reversePosts[indexPath.row]
        
        // songinfo
        cell.albumNameSongName.text = post["song"] as? String
        
        // song cover
        let imageFile = post["cover"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        cell.albumCover.af.setImage(withURL: url)
        
        // caption
        let caption = post["caption"] as! String
        cell.captionFromTheUser.text = caption
        
        // artist name
        cell.artistNameLabel.text = post["artistName"] as? String
        
        // genres
        cell.genreLabel.text = post["genre"] as? String
        cell.genreLabel.layer.masksToBounds = true
        cell.genreLabel.layer.cornerRadius = 8
        
        // sound file
        let sound = post["audio"] as! String
        let soundUrl = URL(string: sound)
        //sendng music url to cell class
        cell.videoPlayerItem = AVPlayerItem.init(url: soundUrl!)
        
        // username
        if (post["username"] != nil){
            let userName = post["username"] as! String
            cell.usernameButton.setTitle(userName, for: .normal)
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "userProfile") {
            let vc = segue.destination as! userProfileViewController
            vc.name = currentPostUsername
         }
        
        if (segue.identifier == "homeComment") {
            let vc = segue.destination as! homeCommentsViewController
            vc.songInfo = currentSong
         }
    }
}
