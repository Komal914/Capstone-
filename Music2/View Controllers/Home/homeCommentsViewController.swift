//
//  homeCommentsViewController.swift
//  Music2
//
//  Created by Sumiya Akter on 4/21/22.
//

import UIKit
import Parse

class homeCommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var homeCommentsTable: UITableView!
    @IBOutlet var homeCommentsTextField: UITextField!
    
    //var posts = [PFObject]()
    var songInfo = String()
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
        
        homeCommentsTable.dataSource = self
        homeCommentsTable.delegate = self
        
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
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let query = PFQuery(className: "comments")
        query.whereKey("song", equalTo: songInfo)
        query.findObjectsInBackground{(comments, error) in
            if comments != nil{
                print("holy comments", comments!)
                self.commentObject = comments!
                
                for comment in comments! {
                    //let first = comments?[0]
                    self.username = comment["user"] as! String
                    //print("does it reach this username part")
                }
                self.homeCommentsTable.reloadData()
            
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
        print("this pf object", reverseComments)
        
        let comment = reverseComments[indexPath.row]
        print("this comments", comment)
        
        let commentUser = comment["user"] as? String
        cell.homeCommentsUsername.text = commentUser
        print("user 2.0", commentUser!)
        
        let caption = comment["comments"] as! String
        cell.homeComment.text = caption
        print("holy fkn caption", caption)
        
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
    
    func updatePFObject(){
        let query2 = PFQuery(className: "comments")
        query2.whereKey("song", equalTo: self.songInfo)
        query2.findObjectsInBackground{(comments, error) in
            if comments != nil{
                print("holy comments part 2", comments!)
                self.commentObject = comments!
                
                for comment in comments! {
                    self.username = comment["user"] as! String
                }
            }
        }
    }

    @IBAction func homeCommentButton(_ sender: Any) {
        
        print("dis user", self.username)
        let thisSong = songInfo
        print("pls work", thisSong)
        let comments = PFObject(className: "comments")
        comments["comments"] = homeCommentsTextField.text!
        comments["song"] = thisSong
        comments["user"] = username
        
        if homeCommentsTextField.text != nil {
            comments.saveInBackground{(succeeded, error) in
                if(succeeded){
                    print("saved!")
                    self.updatePFObject()
                    self.homeCommentsTable.reloadData()
                }
            }
        }
    }
    
}
