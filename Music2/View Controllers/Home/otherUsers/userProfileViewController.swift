//
//  userProfileViewController.swift
//  Music2
//
//  Created by Sumiya Akter on 4/21/22.
//

import UIKit
import Parse

class userProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var userName: UILabel!
    
    
    @IBOutlet weak var followCountLabel: UILabel!
    
    @IBOutlet weak var fansCountLabel: UILabel!
    
    @IBOutlet weak var followButton: UIButton!
    
    
    @IBOutlet weak var bio: UILabel!
    
    
    @IBOutlet weak var followersLabel: UILabel!
    
    
    @IBOutlet weak var fansLabel: UILabel!
    
    
    @IBOutlet weak var postsCountLabel: UILabel!
    
    
    @IBOutlet weak var genreCollectionView: UICollectionView!
    
    @IBOutlet weak var postsCollectionView: UICollectionView!
    
    
    var name = String() //username coming in from home
    var lPosts = [PFObject]() //posts for user
    var isActive:Bool = true //follow button
    var followCount:Int = 0 //follow count is zero unless user is followed
    var uniqueGenre = [String]()
    var userToFollowId = String()
    var userFollowed =  Bool()
    var followList = [String]()
    var fanList = [String]()
    


    override func viewDidLoad() {
    
        super.viewDidLoad()
        //datasources for collecion views
        genreCollectionView.dataSource = self
        postsCollectionView.dataSource = self
        
        //query for the profile bio
        let query = PFQuery(className: "profileInfo")
        query.whereKey("username", equalTo: name)
        
        query.findObjectsInBackground{(profiles, error) in
            if profiles != nil{
                let profile = profiles![0] //going inside array
                self.userToFollowId = profile["appleID"] as! String
                self.bio.text = profile["bio"] as? String
                self.userName.text = self.name
                let followCount = profile["following"] as! String
                let fanCount = profile["fans"] as! String
                self.fanList = profile["fanList"] as! Array
                self.followList = profile["followList"] as! Array
                self.followCountLabel.text = followCount
                self.fansCountLabel.text = fanCount
            }

            else {
                print("error quering for posts: \(String(describing: error))")
            }

        }
        
        //query for the posts from this user
        let query2 = PFQuery(className: "posts")
        query2.whereKey("username", equalTo: name)
        query2.findObjectsInBackground{ (posts, error) in
            if posts != nil {
                self.lPosts = posts!
                for post in self.lPosts{
                    //getting unique genres from the posts the user has posted
                    let genres = post["genre"] as! String
                    if self.uniqueGenre.contains(genres) == false {
                        self.uniqueGenre.append(genres)
                        print("uniqueGenre")
                        print(self.uniqueGenre)
                        
                    }
                }
                self.postsCollectionView.reloadData()
                self.genreCollectionView.reloadData()
            }
        }
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        let currentUser = PFUser.current()
//        let currentUserID = currentUser!["username"] as! String
//
////If the user to follow is the same user logged in
//        if(self.userToFollowId == currentUserID){
//            self.followButton.setTitle("Cannot follow :(", for: .normal)
//            return
//        }
//
//        //if I am not the user in this profile
//        if(self.userToFollowId != currentUserID){
//            //need to query to see if I follow Nisha
//            let query = PFQuery(className: "follow")
//            query.whereKey("user", equalTo: currentUserID)
//            query.findObjectsInBackground{(follow, error) in
//                if follow != nil{
//                    let first = follow![0]
//                    let followingArray = first["following"] as! NSMutableArray
//                    //check if userTofollow in inside FollowingArray
//                    if(followingArray.contains(self.userToFollowId)){
//                        self.followButton.setTitle("unfollow", for: .normal) //already followed
//                        self.followCount = followingArray.count
//                    }
//                    else{
//                        self.followButton.setTitle("follow", for: .normal) //not followed yet
//                        self.followCount = followingArray.count
//                    }
//                }
//
//                else {
//                    print("error quering for posts: \(String(describing: error))")
//                }
//
//            }
//
//        }

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == genreCollectionView)
        {
            return uniqueGenre.count
        }
        let pCount = lPosts.count
        postsCountLabel.text = String(pCount)
        return lPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let albumCell = postsCollectionView.dequeueReusableCell(withReuseIdentifier: "PostsCollectionViewCell", for: indexPath) as! PostsCollectionViewCell
        
        if lPosts.count == 0 {
            print("empty")
        }
        
        if lPosts.count != 0 {
            var reversePosts = [PFObject]()
            reversePosts = self.lPosts.reversed()
            let post = reversePosts[indexPath.row]
            let imageFile = post["cover"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)
            albumCell.albumCover.af.setImage(withURL: url!)
        }
        
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
        
        if (collectionView == genreCollectionView)
        {
            let genreCell = genreCollectionView.dequeueReusableCell(withReuseIdentifier: "UsersGenresCollectionViewCell", for: indexPath) as! UsersGenresCollectionViewCell
            
            genreCell.genreLabel.text = uniqueGenre[indexPath.row]
            print("uniqueGenre")
            print(uniqueGenre)
                genreCell.genreLabel.backgroundColor = random(colors: myColors)
                genreCell.genreLabel.layer.masksToBounds = true
                genreCell.genreLabel.layer.cornerRadius = 8
                return genreCell
        }
        
        return albumCell

        
    }
    
    
    @IBAction func onFollow(_ sender: UIButton) {
        
        print( "fanlsit: ",self.fanList )
        print("follow list: ", self.followList)
    
        //MARK: Follow class
        //the user logged in
        let currentUser = PFUser.current()
        let currentUserID = currentUser!["username"] as! String
        
//If the user to follow is the same user logged in
        if(self.userToFollowId == currentUserID){
            self.followButton.setTitle("Cannot follow :(", for: .normal)
            return
        }
        
        //if I am not the user in this profile
        if(self.userToFollowId != currentUserID){
            //need to query to see if I follow Nisha
            let query = PFQuery(className: "profileInfo")
            query.whereKey("user", equalTo: currentUserID)
            
            query.findObjectsInBackground{(profile, error) in
                if profile != nil{
                    let first = profile![0]
                    print("MY PROFILE: ", first)
                    
                    let followingArray = first["followList"] as! NSMutableArray
                    
                    //if user is already followed
                    if(followingArray.contains(self.userToFollowId) == true){
                        //unfollow user
                        followingArray.remove(self.userToFollowId)
                        first["following"] = followingArray
                        first.saveInBackground()
                        self.followButton.setTitle("follow", for: .normal)
                        self.followCount = followingArray.count
                    }
                    //user needs to be followed
                    else if (followingArray.contains(self.userToFollowId) == false){
                        followingArray.add(self.userToFollowId)
                        first["following"] = followingArray
                        first.saveInBackground()
                        self.followButton.setTitle("unfollow", for: .normal)
                        self.followCount = followingArray.count
                    }
                }
      
                else {
                    print("error quering for posts: \(String(describing: error))")
                }

            }
            
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("COUNT")
        print(self.followCount)

    }

        

    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        let vc = segue.destination as! profileViewController
        vc.currentUserfollowCount = self.followCount
        
         
    }
    

}
