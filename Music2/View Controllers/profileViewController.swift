//
//  profileViewController.swift
//  Music2
//
//  Created by Sumiya Akter on 3/25/22.
//

import UIKit
import Parse

class profileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var postsNumberLabel: UILabel!
    
    @IBOutlet weak var fansLabel: UILabel!
    @IBOutlet weak var fansNumberLabel: UILabel!
    
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followingNumberLabel: UILabel!
    
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var followButton: UIButton!
    @IBAction func editButton(_ sender: Any) {
        performSegue(withIdentifier: "afterEdit", sender: nil)
        
    }
    
    @IBOutlet weak var genreCollectionView: UICollectionView!
    @IBOutlet weak var postsCollectionView: UICollectionView!
    
    //var nickName: String = ""
    var profileUser = [PFObject]()
    var lPosts = [PFObject]()
    //var covers = [PFFileObject]()
    var name: String = ""
    var genre: String = ""
    
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(
        top: 50.0,
        left: 10.0,
        bottom: 50.0,
        right: 10.0)
    
    
    override func viewDidLoad() {
        print("Genres: ", genre)
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        let query = PFQuery(className: "profileInfo")
        query.findObjectsInBackground{(profileInfo, error) in
            if profileInfo != nil{
                //print(profileInfo)
                let first = profileInfo?[1]
                //print(first)
                let name = first?["username"] as! String
                self.usernameLabel.text = name
               
    
                
            }
            else {print("error quering for posts: \(String(describing: error))")}

        }
        
   
        genreCollectionView.dataSource = self
        postsCollectionView.dataSource = self


    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        print("Covers: ", covers)
//        let query = PFQuery(className: "posts")
//        query.includeKey("author")
//
//        query.findObjectsInBackground{ (posts, error) in
//            if posts != nil {
//                self.lPosts = posts!
//                self.postsCollectionView.reloadData()
//            }
//        }
      
        
        
    }
    
        
}

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

// MARK: UICollectionViewDataSource
extension profileViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (collectionView == genreCollectionView)
        {
            return 4
        }
        
        return lPosts.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let albumCell = postsCollectionView.dequeueReusableCell(withReuseIdentifier: "postsCollectionViewCell", for: indexPath) as! postsCollectionViewCell
        
        //MARK: PARSE POSTS
        
        let query = PFQuery(className: "posts")
        query.includeKey("author")
        query.limit = 20
        
        query.findObjectsInBackground{ (posts, error) in
            if posts != nil {
                self.lPosts = posts!
                self.postsCollectionView.reloadData()
                let post = self.lPosts[indexPath.row]
                let user = post["author"] as! PFUser
                
                let imageFile = post["cover"] as! PFFileObject
                let urlString = imageFile.url!
                let url = URL(string: urlString)
                albumCell.albumCover.af.setImage(withURL: url!)
            }
        }
        
        
//        let query = PFQuery(className: "posts")
//        query.findObjectsInBackground{(posts, error) in
//            if posts != nil{
//
//                for post in posts! {
//                    self.posts = posts!
//                    let cover = post["cover"]  as! PFFileObject
//                    self.covers.append(cover)
//                   // print("Covers: ", self.covers)
//                    //self.postsCollectionView.reloadData()
//                    let post = self.posts[indexPath.row]
//                    //print("post: ", post, " at ", indexPath.row)
//                    let user = post["author"] as! PFUser
//                    //print(user)
//                    let imageFile = self.covers[indexPath.row]
//                    //print(imageFile)
//                    let urlString = imageFile.url!
//                    let url = URL(string: urlString)
//                    //print(url)
//                    albumCell.albumCover.af.setImage(withURL: url!)
//
//                }
//
//
//            }
//            else {print("error quering for posts: \(error)")}
//
//        }
        
        
     
        
       
        
        
        
        //cell.backgroundColor = .systemBlue
        //cell.albumCover.image = UIImage(named:"bookmark")
        
        
        if (collectionView == genreCollectionView)
        {
            let genreCell = genreCollectionView.dequeueReusableCell(withReuseIdentifier: "genreCollectionViewCell", for: indexPath) as! genreCollectionViewCell
            //cell2.backgroundColor = .systemTeal
            genreCell.genreLabel.text = "Genre"
            genreCell.genreLabel.backgroundColor = .purple
            return genreCell
        }

        // Configure the cell

        return albumCell
    }
}

// MARK: UICollectionViewDelegate

extension profileViewController: UICollectionViewDelegateFlowLayout {
    // 1
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        // 2
        
        if (collectionView == genreCollectionView)
        {
            let itemsPerRow: CGFloat = 4
            let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
            let availableWidth = view.frame.width - paddingSpace
            let widthPerItem = availableWidth / itemsPerRow
            
            return CGSize(width: widthPerItem, height: widthPerItem/5)
        }
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    // 3
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        
        return sectionInsets.left
    }
}
