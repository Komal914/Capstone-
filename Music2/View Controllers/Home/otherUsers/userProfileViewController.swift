//
//  userProfileViewController.swift
//  Music2
//
//  Created by Sumiya Akter on 4/21/22.
//

import UIKit
import Parse

class userProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == genreCollectionView)
        {
            return 4
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        if (collectionView == genreCollectionView)
//        {
            let genreCell = genreCollectionView.dequeueReusableCell(withReuseIdentifier: "UsersGenresCollectionViewCell", for: indexPath) as! UsersGenresCollectionViewCell
            //cell2.backgroundColor = .systemTeal
            genreCell.genreLabel.text = "Genre"
            genreCell.genreLabel.backgroundColor = .purple
            return genreCell
        //}
        
        

        
    }
    
    
    
    @IBOutlet weak var userName: UILabel!
    
    
    @IBOutlet weak var bio: UILabel!
    
    
    @IBOutlet weak var followersLabel: UILabel!
    
    
    @IBOutlet weak var fansLabel: UILabel!
    
    
    @IBOutlet weak var postsCountLabel: UILabel!
    
    
    @IBOutlet weak var genreCollectionView: UICollectionView!
    
    
    var name = String()
    var lprofile = [PFObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        genreCollectionView.dataSource = self
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

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        

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
