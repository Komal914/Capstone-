//
//  postViewController.swift
//  Music2
//
//  Created by Sumiya Akter on 3/20/22.
//

import UIKit
import StoreKit
import MediaPlayer
import AlamofireImage

class postViewController: UIViewController {
    
    //MARK: - OUTLETS
    //var songData = [String: Any?]() //one dictionary
    //var songData = [[String]]()
    
    var songData = NSDictionary()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func postButton(_ sender: Any) {
    }
    
    
    @IBOutlet weak var albumCoverImageView: UIImageView!
    
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    @IBAction func userCaptionTextField(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        
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
                
                
                
                let url = URL(string:"https://api.music.apple.com/v1/catalog/us/search?types=songs&term=happier+than+ever")!

                var request = URLRequest(url: url)
                request.setValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")

                let session = URLSession.shared

          
                let task = session.dataTask(with: request) {(data, response, error) in
                    guard let data = data else {

                        return
                    }

                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                       self.songData = json?["results"] as! NSDictionary
                       print("got the songs")
                        
                        //print(self.songData)
                        print(self.songData.count)
                        let songs = self.songData["songs"] as! NSDictionary
                        
                        //print(songs)
                        
                        let numberOfSongs = songs["data"] as! NSArray
                        print("amount of song: ", numberOfSongs.count)
                       let firstSong = numberOfSongs[0] as! NSDictionary
                        //print(firstSong)
                       let attributes = firstSong["attributes"] as! NSDictionary
                       let artWork = attributes["artwork"] as! NSDictionary
                       // print(artWork)
                        let urlOfArt = artWork["url"] as! String
                       
                        
                    
                        let replaced = urlOfArt.replacingOccurrences(of: "{w}", with: "212" )
                        let finalUrl = replaced.replacingOccurrences(of: "{h}", with: "431")
                       
                   
                        
                        //print(finalUrl)
                        
                        let url = NSURL(string:finalUrl)
                                let imagedata = NSData.init(contentsOf: url as! URL)

                                if imagedata != nil {
                                    self.albumCoverImageView.image = UIImage(data:imagedata! as Data)
                                }
                                else{
                                    print("NO IMAGE")
                                }
                        
                            
                        DispatchQueue.main.async {
                          //  self.table.reloadData()
                           // print("reloaded")
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
              //  print("after task")
                // Do any additional setup after loading the view.
                
              

        // Do any additional setup after loading the view.
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
