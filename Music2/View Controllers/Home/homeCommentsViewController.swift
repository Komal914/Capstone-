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
    
    var posts = [PFObject]()
    var songInfo = String()
    var commentsArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sends keyboard height to view controller for adjustment
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // dismiss keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

        /*
        let query = PFQuery(className: "posts")
        query.findObjectsInBackground{(posts, error) in
            if posts != nil{
                self.posts = posts! //storing from backend to this file
                //self.commentsArray = posts["comments"]
                self.homeCommentsTable.reloadData()
            }
            
            else {
                print("error quering for posts: \(String(describing: error))")
            }
        }*/
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
        /*let posts = PFObject(className: "posts")
        posts["comments"] = homeCommentsTextview.text
        
        if homeCommentsTextview.text != nil {
            posts.saveInBackground { (succeeded, error)  in
                if (succeeded) {
                    // The object has been saved.
                    print("saved!")
                    print(posts)
                }
                
                else {
                   // print("error on saving data: \(error?.localizedDescription)")
                }
            }
        }*/
    }
}
