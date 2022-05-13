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
    
    var currentUserfollowCount = Int()
    
    @IBAction func editButton(_ sender: Any) {
        performSegue(withIdentifier: "afterEdit", sender: nil)
        
    }
    
    @IBOutlet weak var genreCollectionView: UICollectionView!
    @IBOutlet weak var postsCollectionView: UICollectionView!
    
    var bioText: String = ""
    var profileUser = [PFObject]()
    var lPosts = [PFObject]()
    var name: String = ""
    var genre: String = ""
    var CoverUrlString = [String]()
    var uniqueGenre = [String]()

    
    //private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(
        top: 10.0,
        left: 10.0,
        bottom: 10.0,
        right: 10.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("HELLO",self.currentUserfollowCount)
        //self.navigationController?.navigationBar.isHidden = true
        
        let query = PFQuery(className: "profileInfo")
        
        let user = PFUser.current()
        let userID = user!["username"] as! String
        
        query.whereKey("appleID", equalTo: userID)
        
        query.findObjectsInBackground{(profileInfo, error) in
            if profileInfo != nil{
                
                let array = profileInfo
                let obj = array?[0]
                let userName = obj!["username"] as! String
                let followCount = obj!["followList"] as! NSArray
                let fanCount = obj!["fanList"] as! NSArray
                let followNum = followCount.count
                let fanNum = fanCount.count
                let followS = String(followNum)
                let fanS = String(fanNum)
                print(followCount)
                self.usernameLabel.text = userName
                self.followingNumberLabel.text = followS
                self.fansNumberLabel.text = fanS
            }
            else {
                print("error quering for posts: \(String(describing: error))")
            }
        }
        genreCollectionView.dataSource = self
        postsCollectionView.dataSource = self
    }
    
    func updateLabels() {
        let query2 = PFQuery(className: "profileInfo")
        let user = PFUser.current()
        let userID = user!["username"] as! String
        
        
        query2.whereKey("appleID", equalTo: userID)
        query2.findObjectsInBackground{(bio, error) in
            if bio != nil {
                let newInfo = bio?.first
                let data = newInfo!["bio"] as! String
                self.bioText = data
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
        //query.limit = 20
        
        query.findObjectsInBackground{ (posts, error) in
            if posts != nil {
                self.lPosts = posts!
                for post in self.lPosts{
                    let genres = post["genre"] as! String
                    if self.uniqueGenre.contains(genres) == false {
                        self.uniqueGenre.append(genres)

                    }
                }
                self.postsCollectionView.reloadData()
                self.genreCollectionView.reloadData()
                
            }
        }
        updateLabels()
    }
}

// MARK: UICollectionViewDataSource
extension profileViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (collectionView == genreCollectionView) {
            return uniqueGenre.count
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
        if lPosts.count != 0 {
            var reversePosts = [PFObject]()
            reversePosts = self.lPosts.reversed()
            let post = reversePosts[indexPath.row]
            let imageFile = post["cover"] as! PFFileObject
            let urlString = imageFile.url!
            CoverUrlString.append(urlString)
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
            let genreCell = genreCollectionView.dequeueReusableCell(withReuseIdentifier: "genreCollectionViewCell", for: indexPath) as! genreCollectionViewCell
            
            genreCell.genreLabel.text = uniqueGenre[indexPath.row]
            genreCell.genreLabel.backgroundColor = random(colors: myColors)
            genreCell.genreLabel.layer.masksToBounds = true
            genreCell.genreLabel.layer.cornerRadius = 8
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

            return CGSize(width: widthPerItem, height: widthPerItem/3)
        }
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (postsCollectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size)
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
