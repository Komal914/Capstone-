//
//  PostViewController.swift
//  Music-App
//
//  Created by Komal Kaur on 3/14/22.
//

import UIKit

class PostViewController: UIViewController {
    
//MARK: OUTLETS
    

    @IBAction func searchBarItemButton(_ sender: Any) {
    }
    

    @IBAction func postButton(_ sender: Any) {
    }
    
    
    @IBOutlet weak var albumCoverImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    @IBAction func userCaptionTextfield(_ sender: Any) {
    }
    
    
//MARK: VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Create a Post"

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
