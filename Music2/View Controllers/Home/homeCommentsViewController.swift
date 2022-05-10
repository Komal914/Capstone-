//
//  homeCommentsViewController.swift
//  Music2
//
//  Created by Sumiya Akter on 4/21/22.
//

import UIKit
import Parse

class homeCommentsViewController: UIViewController {
    
    @IBOutlet var homeCommentsTable: UITableView!
    @IBOutlet var homeCommentsTextField: UITextField!
    
    //var posts = [PFObject]()
    var songInfo = String()
    var commentsArray = [String]()
    var commentObject = [PFObject]()
    var username = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("comment view", songInfo)
        // sends keyboard height to view controller for adjustment
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // dismiss keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let query = PFQuery(className: "comments")
        query.includeKey("song")
        query.findObjectsInBackground{(comments, error) in
            if comments != nil{
                self.commentObject = comments!
                for comment in self.commentObject{
                    let songFile = comment["song"] as? String
                    if songFile == self.songInfo
                    {
                        self.username = (comment["user"] as? String)!
                        self.homeCommentsTable.reloadData()
                    }
                }
                //self.username = first["user"] as! String
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //should return number of posts
        return commentObject.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeCommentsTable.dequeueReusableCell(withIdentifier: "HomeCommentCell") as! HomeCommentCell
        var reverseComments = [PFObject]()
        reverseComments = commentObject.reversed()
        
        let comment = reverseComments[indexPath.row]
        
        let commentUser = comment["user"] as? String
        cell.homeCommentsUsername.text = commentUser
        
        let caption = comment["comments"] as! String
        cell.homeComment.text = caption
        
        return cell
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

    @IBAction func homeCommentButton(_ sender: Any) {
        
        let comments = PFObject(className: "comments")
        comments["comments"] = homeCommentsTextField.text
        comments["song"] = songInfo
        comments["user"] = PFUser.current
        
        if homeCommentsTextField.text != nil {
            comments.saveInBackground{(succeeded, error) in
                if(succeeded){
                    print("saved!")
                }
                else {
                    
                }
            }
        }
    }
}
