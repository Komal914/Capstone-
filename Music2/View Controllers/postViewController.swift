//
//  postViewController.swift
//  Music2
//
//  Created by Sumiya Akter on 3/20/22.
//

import UIKit

class postViewController: UIViewController {
    
    //MARK: - OUTLETS
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func postButton(_ sender: Any) {
    }
    
    
    @IBOutlet weak var albumCoverImageView: UIImageView!
    
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    @IBAction func userCaptionTextField(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Post"

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
