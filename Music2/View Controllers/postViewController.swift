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
import DropDown
import SwiftUI

class postViewController: UIViewController, UISearchBarDelegate {
    
    
    //var songData = [String: Any?]() //one dictionary
    //var songData = [[String]]()
    
    //MARK: Global VARIABLES
    
    var songData = NSDictionary()
    var songMenu = [String]()
    
    let menu: DropDown = {
        let menu = DropDown()
        menu.dataSource = ["song1", "song2"]
        menu.cellNib = UINib(nibName: "DropDownCell", bundle: nil)
        menu.customCellConfiguration = { index, title, cell in
            guard let cell = cell as? SearchMenuCell else { return }
        }
        return menu
        
    }()
    
    
 
    //MARK: - OUTLETS
    
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    @IBOutlet weak var viewBelowSearch: UIView!
    
    @IBAction func postButton(_ sender: Any) {
        //this function should send the data over to the home screen view and post our song
    }
    
    
    @IBOutlet weak var albumCoverImageView: UIImageView!
    
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    @IBAction func userCaptionTextField(_ sender: Any) {
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            print("searchText \(searchText)")
           
        }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            print("searchText \(searchBar.text)")
       // print(songMenu)
            menu.show()
        }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            self.searchBar.showsCancelButton = true
            //menu.show()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.showsCancelButton = false
            searchBar.text = ""
            searchBar.resignFirstResponder()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //menu.show()
    }
    
    //MARK: SEARCH BAR SELECTOR
    
    @objc func didTapSearchBar() {
        //menu.show()
    }
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        //MARK: SEARCH BAR SETTINGS
        searchBar.delegate = self
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapSearchBar))
        gesture.numberOfTouchesRequired = 1
        gesture.numberOfTapsRequired = 1
        searchBar.addGestureRecognizer(gesture)
        menu.anchorView = viewBelowSearch
        
        menu.selectionAction = { index, title in
            print("index \(index) at \(title)")
        }
        
        
        //MARK: Storefront Gathering
        //store front
        let controller = SKCloudServiceController()
        controller.requestStorefrontCountryCode { countryCode, error in
            // Use the value in countryCode for subsequent API requests
            if #available(iOS 15.0, *) {
                print("Storyboard:", Storefront.self)
                print(countryCode)
            }
            
            else {
                // Fallback on earlier versions
                print("NO storefront")
            }
        }
        
        
        // user token
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
                let name = attributes["name"] as! String
                self.songMenu.append(name)
                // print(artWork)
                let urlOfArt = artWork["url"] as! String
                    
                let replaced = urlOfArt.replacingOccurrences(of: "{w}", with: "212" )
                let finalUrl = replaced.replacingOccurrences(of: "{h}", with: "431")
                
                print(finalUrl)
                        
                let url = NSURL(string:finalUrl)
                let imagedata = NSData.init(contentsOf: url as! URL)

                if imagedata != nil {
                    self.albumCoverImageView.image = UIImage(data:imagedata! as Data)
                }
                        
                else {
                    print("NO IMAGE")
                }
                        
                DispatchQueue.main.async {
                    // self.table.reloadData()
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


    

