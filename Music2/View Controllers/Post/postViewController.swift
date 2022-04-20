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
import Parse


class postViewController: UIViewController, UISearchBarDelegate {
    
    //MARK: Global VARIABLES
    var songData = NSDictionary()
    var songMenu = [String]()
    var genre = NSArray()
    var audios = [String]()
    var searchText = " "
    var audioIndex = 0
    var sound: String = ""
    var player: AVPlayer? //player for sound
    struct menuData {

        let songName: String
        let albumCover: String

    }
    var images = ["bookmark", "home"]
    let dropDown = DropDown()
 
    //MARK: - OUTLETS
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var captionTextfield: UITextField!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var viewBelowSearch: UIView!
    
    @IBAction func postButton(_ sender: Any) {
        //this function should send the data over to the home screen view and post our song
        
    }
    
    
    @IBAction func onPlayButton(_ sender: Any) {
        //incase the user did not search and my array is empty
        if audios.count == 0 { return}
        //if there is one sound in array, play that sound
        if(audios.count == 1){
            sound = audios[0]
        }
        //more than one audio in array
        else{
            sound = audios.last!
        }
        
        
        
        do {
            //setting up player settings
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            //Url to play
            let url = URL(string: sound)
            let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
            
            player = AVPlayer(playerItem: playerItem)
            //guard incase player is nil
            guard let player = player else {
    
                return
            }
            
            player.play()
    
            
            
        }
        catch {print("something went wrong")}
        
        
    }
    
    
    
    @IBAction func onPauseButton(_ sender: Any) {
        player?.pause()
    }
    
    
    
    
    
    
    
    @IBOutlet weak var albumCoverImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            //print("searchText \(searchText)")
           
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchText = searchBar.text! //user input
        
        //MARK: Replace
        let replaced = searchText.replacingOccurrences(of: " ", with: "+" )
        let base = "https://api.music.apple.com/v1/catalog/us/search?types=songs&term="
        let final = base + replaced
  
        
        // user token
        let developerToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiIsImtpZCI6IjQ1OVlDU0NWN04ifQ.eyJpc3MiOiI0VlMzWEFQWFRWIiwiZXhwIjoxNjYzNTcyNzMzLCJpYXQiOjE2NDc4MDQ3MzN9.J-jb_NnC82o7oSlFvLt84mf7AkNJ3o8Fhhld4ADIDmgY6NfUBVprpD7y1yqX3pjtIUFI85RDxE2yKS12TFmVuA"

        
        let url = URL(string: final)!

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
                let songs = self.songData["songs"] as! NSDictionary
                let numberOfSongs = songs["data"] as! NSArray
            
    
//MARK: ONE SONG DATA
                let firstSong = numberOfSongs[0] as! NSDictionary
                // print(firstSong) api data for one song
                let attributes = firstSong["attributes"] as! NSDictionary
                let artWork = attributes["artwork"] as! NSDictionary
                let name = attributes["name"] as! String
                let artistName = attributes["artistName"] as! String
                
    
                self.songMenu.append(name)
               
//MARK: DROPDOWN DATASOURCE
                self.dropDown.dataSource = self.songMenu
                let albumName = attributes["albumName"] as! String
                let songInfo = albumName + "- " + name
                let previews = attributes["previews"] as! NSArray  //music audio
                print("Music Audio: ",previews)
                let audioDic = previews[0] as! NSDictionary //going inside the music preview array
                print(audioDic)
                let musicUrl = audioDic["url"] as! String
                print(musicUrl)
                self.audios.append(musicUrl)
                
                
               
                
                
                
                
                let songLabel = songInfo
                
                //MARK: GENRE STUFF
                let myBlue = UIColor(red: 62.0/255, green: 174.0/255, blue: 206.0/255, alpha: 1.0)
                let myGreen = UIColor(red: 110.0/255, green: 186.0/255, blue: 64.0/255, alpha: 1.0)
                let myRed = UIColor(red: 247.0/255, green: 118.0/255, blue: 113.0/255, alpha: 1.0)
                let myYellow = UIColor(red: 255.0/255, green: 190.0/255, blue: 106.0/255, alpha: 1.0)
                let lightblue = UIColor(red: 0.00, green: 1.00, blue: 1.00, alpha: 1.00)
                let hotpink = UIColor(red: 1.00, green: 0.00, blue: 0.82, alpha: 1.00)
                let neongreen = UIColor(red: 0.35, green: 1.00, blue: 0.00, alpha: 1.00)
                let yellowgreen = UIColor(red: 0.87, green: 1.00, blue: 0.00, alpha: 1.00)
                let lavender = UIColor(red: 0.87, green: 0.78, blue: 1.00, alpha: 1.00)
                let lightgreen = UIColor(red: 0.85, green: 1.00, blue: 0.78, alpha: 1.00)
                let blue = UIColor(red: 0.66, green: 1.00, blue: 0.97, alpha: 1.00)
                let purple = UIColor(red: 0.50, green: 0.00, blue: 1.00, alpha: 1.00)
                let orange = UIColor(red: 1.00, green: 0.55, blue: 0.00, alpha: 1.00)
                let pink = UIColor(red: 1.00, green: 0.73, blue: 0.85, alpha: 1.00)
                
                let myColors = [myRed, myBlue, myGreen, myYellow, lightblue, hotpink, neongreen, yellowgreen, lavender, lightgreen, blue, purple, orange, pink]
                
                func random(colors: [UIColor]) -> UIColor {
                    return colors[Int(arc4random_uniform(UInt32(myColors.count)))]
                }
                
                let genres = attributes["genreNames"] as! NSArray
                self.genre = genres
                
                let genreInfo = self.genre[0] as! String
                //print("GENRE", genreInfo)
                DispatchQueue.main.async {
                    //STORE THIS
                self.genresLabel.text = genreInfo
                    self.artistNameLabel.text = artistName
                    self.genresLabel.backgroundColor = random(colors: myColors)
                    self.genresLabel.layer.masksToBounds = true
                    self.genresLabel.layer.cornerRadius = 8
                }
                
                let urlOfArt = artWork["url"] as! String
                    
                let replaced = urlOfArt.replacingOccurrences(of: "{w}", with: "212" )
                let finalUrl = replaced.replacingOccurrences(of: "{h}", with: "431")
               
                        
                let url = NSURL(string:finalUrl)
                let imagedata = NSData.init(contentsOf: url! as URL)
//MARK: imageData
                
                //MARK: UI Settings
                //adding this dispatch queue elimates warnings
                DispatchQueue.main.async {
                    if imagedata != nil {
                        //STORE THESE TWO
                        self.albumCoverImageView.image = UIImage(data:imagedata! as Data)
                        self.songName.text = songLabel
                    }
                            
                    else {
                       // print("NO IMAGE")
                    }
                }
            }
                    
            catch {
            }
        }
        
        task.resume()
            dropDown.show()
        }
    
    @IBAction func onPost(_ sender: Any) {
        print("starting post")
        //Saving the post in the backend
        let posts = PFObject(className: "posts")
        posts["author"] = PFUser.current()
        posts["appleID"] = PFUser.current()?.username
        posts["username"] = " "
        
        posts["genre"] = self.genresLabel.text
        posts["song"] = self.songName.text
        posts["caption"] = self.captionTextfield.text!
        posts["artistName"] = self.artistNameLabel.text!
        
        let imageData = albumCoverImageView.image!.pngData()
        let file = PFFileObject(data: imageData!)
        posts["cover"] = file
        posts["audio"] = audios.last!
        
        posts.saveInBackground { (succeeded, error)  in
            if (succeeded) {
                // The object has been saved.
              print("saved!")
            } else {
               // print("error on saving data: \(error?.localizedDescription)")
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            self.searchBar.showsCancelButton = true
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
        //dropDown.show()
    }
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        
        //MARK: Storefront Gathering
        //store front
        let controller = SKCloudServiceController()
        controller.requestStorefrontCountryCode { countryCode, error in
            // Use the value in countryCode for subsequent API requests
            if #available(iOS 15.0, *) {
                //print("Storyboard:", Storefront.self)
                //print(countryCode)
            }
            
            else {
                // Fallback on earlier versions
                // print("NO storefront")
            }
        }
        
        func requestUserToken(forDeveloperToken developerToken: String,
                              completionHandler: @escaping (String?, Error?) -> Void){
            
        }
        
        // Do any additional setup after loading the view.
        //MARK: SEARCH BAR SETTINGS
        searchBar.delegate = self
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapSearchBar))
        gesture.numberOfTouchesRequired = 1
        gesture.numberOfTapsRequired = 1
        searchBar.addGestureRecognizer(gesture)
        
        //MARK: Dropdown settings
        dropDown.anchorView = viewBelowSearch
        dropDown.cellNib = UINib(nibName: "DropDownCell", bundle: nil)
        dropDown.customCellConfiguration = {index, title, cell in
            guard cell is SearchMenuCell else {
                return
            }
            //cell.albumCover.image = UIImage(systemName: self.images[index])
        }
        
        dropDown.selectionAction = { index, title in
           // print("index \(index) at \(title)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let data = genresLabel.text
        //print(data)
                
            // Create a new variable to store the instance of the SecondViewController
            // set the variable from the SecondViewController that will receive the data
        let destinationVC = segue.destination as! profileViewController
        destinationVC.genre = data! 
        
        
    }
    
}


    

