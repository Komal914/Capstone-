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
    //var selectedPost = [PFObject]()
    var imageURLS = String()
    var songImage: UIImage!
    var songTitle = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MY URLS AS STRINGS: ", imageURLS)
//        let imageFile = post["cover"] as! PFFileObject
//        let urlString = imageFile.url!
//        let url = URL(string: urlString)
        //songImageView.af.setImage(withURL: url!)

        // Do any additional setup after loading the view.
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
