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
    
    var bioText: String = ""
    var profileUser = [PFObject]()
    var lPosts = [PFObject]()
    //var cover: PFFileObject
    var name: String = ""
    var genre: String = ""
    var CoverUrlString = [String]()
    //var thumbnail: UIImage!
    
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(
        top: 50.0,
        left: 10.0,
        bottom: 50.0,
        right: 10.0)
    
    
    override func viewDidLoad() {
        //print("Genres: ", genre)
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        //bioLabel.text = bioText
        
        
        let query = PFQuery(className: "profileInfo")
        
        let user = PFUser.current()
        //print("user: ", user)
        let userID = user!["username"] as! String
        //print(userID)
        
        query.whereKey("appleID", equalTo: userID)
        
        query.findObjectsInBackground{(profileInfo, error) in
            if profileInfo != nil{
                
                let array = profileInfo
              
                let obj = array?[0]
                let userName = obj!["username"] as! String
                //let bio = obj!["bio"] as! String
                //self.bioLabel.text = bio
                //self.bioLabel.reloadInputViews()
                self.usernameLabel.text = userName
            }
            else {print("error quering for posts: \(String(describing: error))")}
        }
        
   
        genreCollectionView.dataSource = self
        postsCollectionView.dataSource = self


    }
    
    func updateLabels() {
        let query2 = PFQuery(className: "profileInfo")
        let user = PFUser.current()
        let userID = user!["username"] as! String
        
        
        query2.whereKey("appleID", equalTo: userID)
        //print(profInfo)
        query2.findObjectsInBackground{(bio, error) in
            if bio != nil {
                //print(bio!)
                var newInfo = bio?.first
                //print(newInfo!)
                var data = newInfo!["bio"] as! String
                self.bioText = data
                //data = self.editBioTextField.text!
                //self.bioLabel.text = data
                //print(data)
                self.bioLabel.text = self.bioText

            }
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //MARK: PARSE POSTS
        
        let query = PFQuery(className: "posts")
        
        let user = PFUser.current()
        let userID = user!["username"] as! String
                
        query.whereKey("appleID", equalTo: userID)
        query.includeKey("author")
        query.limit = 20
        
        query.findObjectsInBackground{ (posts, error) in
            if posts != nil {
                self.lPosts = posts!
                self.postsCollectionView.reloadData()
                
            }
        }
        updateLabels()
        
        
        //print(bioText)
        
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
        let pCount = lPosts.count
        postsNumberLabel.text = String(pCount)
        return lPosts.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let albumCell = postsCollectionView.dequeueReusableCell(withReuseIdentifier: "postsCollectionViewCell", for: indexPath) as! postsCollectionViewCell
        
        if lPosts.count == 0 {
            print("empty")
        }
        
//avoids the app from crashing
//the lpost array is empty while the database is being queried
        if lPosts.count != 0 {
            var reversePosts = [PFObject]()
            reversePosts = self.lPosts.reversed()
            let post = reversePosts[indexPath.row]
            //let user = post["author"] as! PFUser
            let imageFile = post["cover"] as! PFFileObject
            
            let urlString = imageFile.url!
            CoverUrlString.append(urlString)
            let url = URL(string: urlString)
            albumCell.albumCover.af.setImage(withURL: url!)
        }

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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let cell = collectionView.cellForItem(at: indexPath) as! postsCollectionViewCell
        let vc1 = storyboard?.instantiateViewController(withIdentifier: "songViewController") as? songViewController
        
        //print(idk)
        
        let cover = CoverUrlString[indexPath.row]
        
        print("MY COVER:", cover)
        
        vc1!.imageURLS = cover
        
        //vc1?.songImage = lPosts[indexPath.row]
        //albumCell = cell.albumCover.image
        
        //vc1?.songTitle = smth[indexPath.row]
        self.navigationController?.pushViewController(vc1!, animated: true)
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
