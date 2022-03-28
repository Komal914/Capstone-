//
//  HomeViewController.swift
//  Music2
//
//  Created by Komal Kaur on 3/20/22.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    

    
    @IBOutlet weak var table: UITableView!
    var user: User?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationItem.title = "Home"
        self.navigationController?.navigationBar.isHidden = true
        
        table.delegate = self
        table.dataSource = self
        
        print(user?.debugDescription ?? "")
        print("homeview ERROR")
        
        print("Print statement for ID: ", user?.id ?? "default")
        

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
