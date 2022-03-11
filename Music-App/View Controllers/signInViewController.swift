//
//  ViewController.swift
//  Music-App
//
//  Created by Komal Kaur on 3/8/22.
//

import UIKit

class signInViewController: UIViewController {
    
//MARK: OUTLETS
    @IBOutlet weak var usernameTextfield: UITextField!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    @IBAction func onSignInToAppleMusicButton(_ sender: Any) {
        
        //we need to authenticate the user here with the apple API
        //for now, you can log in by just clicking the button
        performSegue(withIdentifier: "loginToAppleMusic", sender: self)
        
    }
    
    
    
    
//MARK: VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }


}

