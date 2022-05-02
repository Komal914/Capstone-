//
//  userProfileViewController.swift
//  Music2
//
//  Created by Sumiya Akter on 4/21/22.
//

import UIKit
import Parse

class userProfileViewController: UIViewController {
    
    
    @IBOutlet weak var userName: UILabel!
    
    
    @IBOutlet weak var bio: UILabel!
    
    
    @IBOutlet weak var followersLabel: UILabel!
    
    
    @IBOutlet weak var fansLabel: UILabel!
    
    
    @IBOutlet weak var postsCountLabel: UILabel!
    
    
    var name = String()
    var lprofile = [PFObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
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
