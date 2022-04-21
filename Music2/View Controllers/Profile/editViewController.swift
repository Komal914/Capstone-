//
//  editViewController.swift
//  Music2
//
//  Created by Sumiya Akter on 4/12/22.
//

import UIKit
import Parse
import LocalAuthentication

class editViewController: UIViewController {
    
    
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBAction func doneButton(_ sender: Any) {
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


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let bioText = editBioTextField.text ?? ""

        let destinationVC = segue.destination as! profileViewController
        destinationVC.bioText = bioText
    }

}
