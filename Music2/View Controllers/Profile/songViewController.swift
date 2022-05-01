//
//  songViewController.swift
//  Music2
//
//  Created by Sumiya Akter on 4/21/22.
//

import UIKit
import Parse

class songViewController: UIViewController {
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var songInfoLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var songImageView: UIImageView!
    //var selectedPost = [PFFileObject]()
    var imageURLS = String()
    var songImage: UIImage!
    var songTitle = ""
    var lPosts = [PFObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MY URLS AS STRINGS: ", imageURLS)
        
        
        let url = URL(string: self.imageURLS)
        self.songImageView.af.setImage(withURL: url!)
        

        // Do any additional setup after loading the view.
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let query = PFQuery(className: "posts")
        
        query.includeKey("cover")
        query.findObjectsInBackground{(posts, error) in
            if posts != nil {
                self.lPosts = posts!
                for post in self.lPosts{
                    print("post: ", post)
                    let imageFile = post["cover"] as? PFFileObject
                    let fileString = imageFile?.url
                    if fileString == self.imageURLS
                    {
                        self.songInfoLabel.text = post["song"] as? String
                        self.genreLabel.text = post["genre"] as? String
                        self.artistLabel.text = post["artistName"] as? String
                    }
                    //print("here lies the image: ", imageFile)
                }
                //print("Here Lies All the POsts: ", self.lPosts)
                
            }
        }
        updateValues()
    }
    
    
    
    func updateValues ()
    {
        print("Round TWO: ", lPosts)
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
