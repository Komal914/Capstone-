//
//  MusicVideosViewController.swift
//  Music2
//
//  Created by Komal Kaur on 3/20/22.
//

import UIKit
import StoreKit
import MediaPlayer

class MusicVideosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    var videoData = [[String: Any?]]() //array of dictionaries
    var filteredVideoData = [[String: Any?]]()
    
//MARK: OUTLETS
        
    @IBOutlet weak var table: UITableView!

    
//MARK: VIEWDIDLOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Music Videos"
        
        table.delegate = self
        table.dataSource = self
//MARK: API REQUEST
        //store front
        
       
        
        
        
        
        
        
        let controller = SKCloudServiceController()
        controller.requestStorefrontCountryCode { countryCode, error in
            // Use the value in countryCode for subsequent API requests
            if #available(iOS 15.0, *) {
                print("Storyboard:", Storefront.self)
            } else {
                // Fallback on earlier versions
                print("NO storefront")
            }
        }
        
        
        //user token
        let developerToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiIsImtpZCI6IjQ1OVlDU0NWN04ifQ.eyJpc3MiOiI0VlMzWEFQWFRWIiwiZXhwIjoxNjYzNTcyNzMzLCJpYXQiOjE2NDc4MDQ3MzN9.J-jb_NnC82o7oSlFvLt84mf7AkNJ3o8Fhhld4ADIDmgY6NfUBVprpD7y1yqX3pjtIUFI85RDxE2yKS12TFmVuA"

        
        func requestUserToken(forDeveloperToken developerToken: String,
                              completionHandler: @escaping (String?, Error?) -> Void){
            print()
        }
        
        
        
//MARK: API REQUEST
        
        let baseAPIUrl = "https://api.music.apple.com/v1/catalog/"
        
        //let base2Url = baseUrl + Storefront
        
        
        
        let url = URL(string:"https://api.music.apple.com/v1/catalog/us/music-videos/1553279848")!

        var request = URLRequest(url: url)
        request.setValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")

        let session = URLSession.shared

        print("Starting task")
        let task = session.dataTask(with: request) { [self] data, response, error in
            guard let data = data else {

                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                self.videoData = json?["data"] as! [[String: Any]]
                self.filteredVideoData = self.videoData.flatMap { $0 }
                //print(filteredVideoData)
                //print("inside the do")
            }
            catch {
            }

        }
        task.resume()
        print("after task")
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
        //let video = filteredVideoData["data"]
                
        print("Number of recipes in tableview: ", filteredVideoData.count)
                
        //getting title
        //let title = video["title"] as? String
        print("title below: ")
        //print(title)
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
