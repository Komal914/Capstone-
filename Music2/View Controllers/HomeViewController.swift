//
//  HomeViewController.swift
//  Music2
//
//  Created by Komal Kaur on 3/20/22.
//

import UIKit
import StoreKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    

    
    @IBOutlet weak var table: UITableView!
    var user: User?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Home"
        
        table.delegate = self
        table.dataSource = self
        
        func getUserToken() {
            let developerToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiIsImtpZCI6IjQ1OVlDU0NWN04ifQ.eyJpc3MiOiI0VlMzWEFQWFRWIiwiZXhwIjoxNjQ3OTM4MTg0LCJpYXQiOjE2NDc4OTQ5ODR9.sKU-6mJISE8Q-_vGLdWS1aUuEXxl3ufxrZO3jpI6Ghgw9o-8ZnafwP3IV_6i-Gqbz_JFr54GLBP3xJvu4CNK8w"
            var userToken = String()
            
            SKCloudServiceController().requestUserToken(forDeveloperToken: developerToken) { (receivedToken, error) in
                guard error == nil else { return }
                
                if let token = receivedToken {
                    userToken = token
                    print(userToken)
                }
            }
        }
        
        print(user?.debugDescription)
        
        print("Print statement for ID: ", user?.id)
        

        // Do any additional setup after loading the view.
    }
    
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //should return number of posts
        return 1
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 550 //or whatever you need
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = table.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeCell
        
      
        
        return cell
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
