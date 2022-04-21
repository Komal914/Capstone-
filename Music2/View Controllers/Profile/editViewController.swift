//
//  editViewController.swift
//  Music2
//
//  Created by Sumiya Akter on 4/12/22.
//

import UIKit
import Parse

class editViewController: UIViewController {
    
    var bioText = ""
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBAction func doneButton(_ sender: Any) {
        
        let query = PFQuery(className: "profileInfo")
        let user = PFUser.current()
        //print("user: ", user)
        let userID = user!["username"] as! String
        //print(userID)
        query.whereKey("appleID", equalTo: userID)
        
        query.findObjectsInBackground{(profileInfo, error) in
            if profileInfo != nil{
                let profInfo = PFObject(className: "profileInfo")
                let array = profileInfo
                let obj = array?[0]
                var bio = obj!["bio"] as! String
                bio = self.editBioTextField.text!
                profInfo["bio"] = self.editBioTextField.text!
                profInfo.saveInBackground()
            }
            else {print("error quering for posts: \(String(describing: error))")}
        }
//        let profileInfo = PFObject(className:"profileInfo")
//        profileInfo["appleID"] = PFUser.current()?.username
//        profileInfo["bio"] = editBioTextField.text!
//
//        profileInfo.saveInBackground { (succeeded, error)  in
//            if (succeeded) {
//                // The object has been saved.
//            } else {
//                print("error on saving data: \(String(describing: error?.localizedDescription))")
//            }
//        }
//
        self.dismiss(animated: true, completion: nil)
        self.bioText = editBioTextField.text!
    }
    @IBOutlet weak var editBioTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
