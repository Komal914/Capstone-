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
    
    
    var name = String()
    //var lprofile = [PFObject]()
    var lPosts = [PFObject]()

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
        if (collectionView == genreCollectionView)
        {
            let genreCell = genreCollectionView.dequeueReusableCell(withReuseIdentifier: "UsersGenresCollectionViewCell", for: indexPath) as! UsersGenresCollectionViewCell
            //cell2.backgroundColor = .systemTeal
            genreCell.genreLabel.text = "Genre"
            genreCell.genreLabel.backgroundColor = .purple
            return genreCell
        }
        
        return albumCell

        
    }
    
    
    @IBAction func onFollow(_ sender: UIButton) {
        
        //change the label to unfollow for this profile
        // store the follow unfollow property on parse for the current user

        
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
