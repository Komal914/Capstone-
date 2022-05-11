//
//  commentsViewController.swift
//  Music2
//
//  Created by Sumiya Akter on 4/12/22.
//

import UIKit
import Parse

class videoCommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var addCommentTextfield: UITextField!
    @IBOutlet weak var commentButton: UIButton!
    @IBAction func onComment(_ sender: Any) {
        //print("dis user", self.username)
        let thisSong = videoInfo
        //print("pls work", thisSong)
        let comments = PFObject(className: "comments")
        comments["comments"] = addCommentTextfield.text!
        comments["song"] = thisSong
        comments["user"] = username
        
        if addCommentTextfield.text != nil {
            comments.saveInBackground{(succeeded, error) in
                if(succeeded){
                    print("saved!")
                    //   self.homeCommentsTable.reloadData()
                }
                else {
                    
                }
            }
        }
        self.commentsTableView.reloadData()
    }
    
    var videoInfo = String()
    var commentObject = [PFObject]()
    var username = String()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentObject.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentsTableView.dequeueReusableCell(withIdentifier: "videoCommentCell") as! videoCommentCell
        var reverseComments = [PFObject]()
        reverseComments = commentObject.reversed()
        let comment = reverseComments[indexPath.row]
        let commentUser = comment["user"] as? String
        let caption = comment["comments"] as! String

        cell.usernameLabel.text = commentUser
        cell.commentLabel.text = caption
        
        return cell
    }

    @IBOutlet weak var commentsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentsTableView.dataSource = self
        commentsTableView.delegate = self
        
        // sends keyboard height to view controller for adjustment
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // dismiss keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let currentUser = PFUser.current()
        let query = PFQuery(className: "profileInfo")
        let userID = currentUser!["username"] as! String
        query.whereKey("appleID", equalTo: userID)
        query.findObjectsInBackground{(profileInfo, error) in
            if profileInfo != nil {
                let first = profileInfo![0]
                self.username = first["username"] as! String
                print("query user", self.username)
            }
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let query = PFQuery(className: "comments")
        query.includeKey("song")
        query.findObjectsInBackground{(comments, error) in
            if comments != nil{
                print("holy comments", comments!)
                self.commentObject = comments!
                
                var reverseComments = [PFObject]()
                reverseComments = comments!.reversed()
                let first = reverseComments[0]
                let songFile = first["song"] as? String
                if songFile == self.videoInfo {
                    self.username = first["user"] as! String
                    self.commentsTableView.reloadData()
                }
                
            }
        }
    }
    
    // sends keyboard notification to self controller about height
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    // hides keyboard after use
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    // hides keyboard if anywhere else on the application is touched
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}
