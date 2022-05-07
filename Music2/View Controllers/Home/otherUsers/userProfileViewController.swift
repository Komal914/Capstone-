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
                let profile = profiles![0]
                //print("Profile Info")
              //  print(profile)
               // print (self.followCount)
                self.bio.text = profile["bio"] as? String
                self.userName.text = self.name
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
                self.postsCollectionView.reloadData()
                
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == genreCollectionView)
        {
            return 4
        }
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
            //let user = post["author"] as! PFUser
            let imageFile = post["cover"] as! PFFileObject
            //imageBinFile.append(imageFile)
            let urlString = imageFile.url!
           // CoverUrlString.append(urlString)
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
            //cell2.backgroundColor = .systemTeal
            genreCell.genreLabel.text = "Genre"
            genreCell.genreLabel.backgroundColor = random(colors: myColors)
            genreCell.genreLabel.layer.masksToBounds = true
            genreCell.genreLabel.layer.cornerRadius = 8
            return genreCell
        }
        
        return albumCell

        
    }
    
    
    @IBAction func onFollow(_ sender: UIButton) {
        
        //change the label to unfollow for this profile
        // store the follow unfollow property on parse for the current user
        
       
        
        if isActive {
            isActive = false
            followButton.setTitle("Unfollow", for: .normal)

        }
        
        else{
            isActive = true
            followButton.setTitle("Follow", for: .normal)
            //followCount = 1
            let profileInfo = PFObject(className: "profileInfo")
            //profileInfo["followCount"] = followCount
        }

        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
         
    }
    

}
