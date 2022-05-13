//
//  welcomeViewController.swift
//  Music2
//
//  Created by Sumiya Akter on 4/9/22.
//

import UIKit
import Parse
import Lottie

class welcomeViewController: UIViewController {
    
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var welcomeAnimation: AnimationView!
    @IBOutlet weak var nameTextField: UITextField!
    
    var emptyArray = [String]()
    @IBAction func onDoneButton(_ sender: Any) {
        performSegue(withIdentifier: "afterName" , sender: nil)
        
        let profileInfo = PFObject(className:"profileInfo")
        profileInfo["appleID"] = PFUser.current()?.username
        profileInfo["username"] = nameTextField.text!
        profileInfo["following"] = "0"
        profileInfo["fans"] = "0"
        profileInfo["bio"] = "Hello!"
        profileInfo["fanList"] = self.emptyArray
        profileInfo["followList"] = self.emptyArray
        profileInfo.saveInBackground { (succeeded, error)  in
            if (succeeded) {
                // The object has been saved.
            }
            
            else {
                print("error on saving data: \(String(describing: error?.localizedDescription))")
            }
        }
        
//        let follow = PFObject(className:"follow")
//        follow["user"] = PFUser.current()?.username
//        follow["fans"] = self.emptyArray
//        follow["following"] = self.emptyArray
//        follow.saveInBackground{(succeeded, error)  in
//            if (succeeded) {
//                // The object has been saved.
//            } else {
//                print("error on saving data: \(error?.localizedDescription)")
//            }}
        
        let name = nameTextField.text!
        //print("this is the user name : ",name)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Animation for welcome screen
        welcomeAnimation.loopMode = .loop
        welcomeAnimation.play()
        
        // Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}
