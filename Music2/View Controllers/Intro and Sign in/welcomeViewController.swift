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
    //var name = String()
    @IBAction func onDoneButton(_ sender: Any) {
        performSegue(withIdentifier: "afterName" , sender: nil)
        
        let profileInfo = PFObject(className:"profileInfo")
        profileInfo["appleID"] = PFUser.current()?.username
        profileInfo["username"] = nameTextField.text!
        profileInfo["followers"] = "0" 
        //name = nameTextField.text!
        profileInfo.saveInBackground { (succeeded, error)  in
            if (succeeded) {
                // The object has been saved.
            } else {
                print("error on saving data: \(error?.localizedDescription)")
            }
        }
        
        let name = nameTextField.text!
        print("this is the user name : ",name)
        
        
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
    

     //MARK: - Navigation

   //  In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let name = nameTextField.text!
        print("this is the user name : ",name)
//        //let tabCtrl = segue.destination as! UITabBarController
//       // let destinationVC = tabCtrl.viewControllers![3] as! profileViewController // Assuming home view controller is in the first tab, else update the array index
//
//
//        let tabCtrl: UITabBarController = segue.destination as! UITabBarController
//        let destinationVC = tabCtrl.viewControllers![3] as! UINavigationController
//
//        let last = destinationVC.viewControllers as! profileViewController
//        
//        print("TEST: ", last.usernameLabel.text)

       // last.usernameLabel.text = name
        //self.navigationController?.pushViewController(destinationVC, animated: false)
    }
}
