//
//  welcomeViewController.swift
//  Music2
//
//  Created by Sumiya Akter on 4/9/22.
//

import UIKit
import Parse

class welcomeViewController: UIViewController {
    
    @IBOutlet weak var instructionsLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBAction func onDoneButton(_ sender: Any) {
        performSegue(withIdentifier: "afterName" , sender: nil)
        
        let profileInfo = PFObject(className:"profileInfo")
        profileInfo["appleID"] = PFUser.current()?.username
        profileInfo["username"] = nameTextField.text!
        profileInfo.saveInBackground { (succeeded, error)  in
            if (succeeded) {
                // The object has been saved.
            } else {
                print("error on saving data: \(error?.localizedDescription)")
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
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
