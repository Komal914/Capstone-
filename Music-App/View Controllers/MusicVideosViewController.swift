//
//  MusicVideosViewController.swift
//  Music-App
//
//  Created by Komal Kaur on 3/15/22.
//

import UIKit

class MusicVideosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    
    
//MARK: OUTLETS
    

    
    @IBOutlet weak var table: UITableView!
    
    
    
    
    
    
    
    
    
    
//MARK: VIEWDIDLOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Music Videos"
        
        table.delegate = self
        table.dataSource = self

        // Do any additional setup after loading the view.
    }
    

//MARK: TABLE FUNCTIONS
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 700//or whatever you need
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //should return .count of the number of music videos
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "MusicVideosCell") as! MusicVideosCell
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
