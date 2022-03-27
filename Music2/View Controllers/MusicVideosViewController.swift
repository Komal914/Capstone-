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
        self.navigationController?.navigationBar.isHidden = true
        
        table.delegate = self
        table.dataSource = self
   
//MARK: API REQUEST
        //store front
        
       
        
        
        
        
        
        
        let controller = SKCloudServiceController()
        controller.requestStorefrontCountryCode { countryCode, error in
            // Use the value in countryCode for subsequent API requests
            if #available(iOS 15.0, *) {
                print("Storyboard:", Storefront.self)
                print(countryCode)
            } else {
                // Fallback on earlier versions
                print("NO storefront")
            }
        }
        
        
        //user token
        let developerToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiIsImtpZCI6IjQ1OVlDU0NWN04ifQ.eyJpc3MiOiI0VlMzWEFQWFRWIiwiZXhwIjoxNjYzNTcyNzMzLCJpYXQiOjE2NDc4MDQ3MzN9.J-jb_NnC82o7oSlFvLt84mf7AkNJ3o8Fhhld4ADIDmgY6NfUBVprpD7y1yqX3pjtIUFI85RDxE2yKS12TFmVuA"

        
        func requestUserToken(forDeveloperToken developerToken: String,
                              completionHandler: @escaping (String?, Error?) -> Void){
            
        }
        
        
        
//MARK: API REQUEST
        
        //let baseAPIUrl = "https://api.music.apple.com/v1/catalog/"
        
        //let base2Url = baseUrl + Storefront
        
        
        
        let url = URL(string:"https://api.music.apple.com/v1/catalog/us/music-videos?ids=1553279848,1549013065")!

        var request = URLRequest(url: url)
        request.setValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")

        let session = URLSession.shared

  
        let task = session.dataTask(with: request) {(data, response, error) in
            guard let data = data else {

                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
               self.videoData = json?["data"] as! [[String: Any]]
              // print("got the goods")
                DispatchQueue.main.async {
                    self.table.reloadData()
                  //  print("reloaded")
                }
                
                //self.filteredVideoData = self.videoData.flatMap { $0 }
                //print("Json Below:")
                //print(videoData)
                //print("inside the do")
            }
            catch {
            }
            

        }
        task.resume()
       // print("after task")
        // Do any additional setup after loading the view.
        
        table.reloadData()
    }
    

//MARK: TABLE FUNCTIONS
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 700//or whatever you need
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        //should return .count of the number of music videos
        return videoData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "MusicVideosCell") as! MusicVideosCell
        
                
        let video = videoData[indexPath.row] //each video data
        let attributes = video["attributes"] //attributes for each video
       // print(attributes)
        var data = [attributes] as? Any

        
        
        //let thing = video["attributes"][Optional("url")] as? String
      //  print("thing: ", thing)
       // cell.artistNameLabel.text = video["albums"] as? String
       //print("video below:")
       // print(video.count)
       // print("Number of videos in tableview: ", videoData.count)
       // print("title of the artist: ", title)
        
                
        //getting title
        //let title = video["title"] as? String
        //print("title below: ")
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
