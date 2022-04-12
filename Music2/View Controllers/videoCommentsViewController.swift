//
//  commentsViewController.swift
//  Music2
//
//  Created by Sumiya Akter on 4/12/22.
//

import UIKit

class videoCommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
  
    
    
    @IBOutlet weak var table: UITableView!
    
    
    @IBOutlet weak var addCommentTextfield: UITextField!
    
    
    @IBOutlet weak var commentButton: UIButton!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 25
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "videoCommentCell") as! videoCommentCell
        cell.usernameLabel.text = "Username"
        cell.commentLabel.text = "This is a comment"
        return cell
    }
    

    @IBOutlet weak var commentsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self

        // Do any additional setup after loading the view.
    }

}
