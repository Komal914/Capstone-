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
import Lottie

class postViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Global Variables
    var userName = [PFObject]()
    var songData = NSDictionary()
    var songMenu = [String]()
    var genreArray = NSArray()
    var audios = [String]()
    var searchText = " "
    var audioIndex = 0
    var sound: String = ""
    var player: AVPlayer? //player for sound
    let dropDown = DropDown()
    //table view vars
    var ArtistName = String()
    var SongInfo = String()
    var AlbumCover = UIImageView()
    var genre = String()
    var Caption = String()
    var searched = false
    var check = 0
    
    var girlAnimation: AnimationView?
    
 
    //MARK: - OUTLETS
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var viewBelowSearch: UIView!
    @IBOutlet weak var caption: UITextField!
    @IBOutlet weak var postButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //startAnimation()
        
        //self.navigationController?.navigationBar.isHidden = true
        table.delegate = self
        table.dataSource = self
        
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
        }
        
        dropDown.selectionAction = { index, title in
           // print("index \(index) at \(title)")
        }
    }
    
    //MARK: Animation
    func startAnimation(){
        girlAnimation = .init(name: "girl-listening")
        girlAnimation!.frame = CGRect(x: 50, y:view.frame.width/2 , width: 300, height: 300)
        girlAnimation!.contentMode = .scaleAspectFit
        view.addSubview(girlAnimation!)
        girlAnimation!.loopMode = .loop
        girlAnimation!.animationSpeed = 1
        girlAnimation!.play()
    }
    
    @objc func stopAnimation(){
        girlAnimation?.stop()
        view.subviews.last?.removeFromSuperview()
        girlAnimation?.sendSubviewToBack(view)
    }
    
    @IBAction func onPlayButton(_ sender: Any) {
        //incase the user did not search and my array is empty
        if audios.count == 0 { return}
        //if there is one sound in array, play that sound
        if(audios.count == 1){
            sound = audios[0]
        }
        //more than one audio in array
        else {
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
        catch {
            print("something went wrong")
        }
    }
    
    @IBAction func onPauseButton(_ sender: Any) {
        player?.pause()
    }
    
    @IBAction func onPost(_ sender: Any) {
        //print("1")
        let obj = self.userName[0]
        let name = obj["username"] as! String
        let username = name
        //print("2")
        let posts = PFObject(className: "posts")
        posts["author"] = PFUser.current()
        posts["appleID"] = PFUser.current()?.username
        posts["genre"] = genre
        posts["song"] = SongInfo
        let caption = caption.text!
        //print("caption", caption)
        posts["caption"] = caption
        posts["artistName"] = ArtistName
        posts["username"] = username
        //print("3")
        let imageData = AlbumCover.image!.pngData()
        let file = PFFileObject(data: imageData!)
        posts["cover"] = file
        //print("4")
        if audios.count != 0 {
            posts["audio"] = audios.last!
        }
        //print("6")
        posts.saveInBackground { (succeeded, error)  in
            if (succeeded) {
                // The object has been saved.
                print("saved!")
                //print(posts)
                self.tabBarController!.selectedIndex = 1
            }
            
            else {
               // print("error on saving data: \(error?.localizedDescription)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 450                      //or whatever you need
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = table.dequeueReusableCell(withIdentifier: "PostScreenCell") as! PostScreenCell
        // hiding cell until user searches
        if searched == false {
            cell.isHidden = true
        }
        
        else {
            cell.isHidden = false
        }
        
        // updating data
        let name = self.ArtistName
        cell.artistName.text = name
        cell.songInfo.text = SongInfo
        let cover = self.AlbumCover.image
        cell.albumCover.image = cover
        cell.genres.text = genre
        let pink = UIColor(red: 0.91, green: 0.27, blue: 0.62, alpha: 1.00)
        cell.genres.backgroundColor = pink 
        cell.genres.layer.masksToBounds = true
        cell.genres.layer.cornerRadius = 8
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            //print("searchText \(searchText)")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        stopAnimation()
        self.check = 1
        
        caption.isHidden = false
        postButton.isHidden = false
        searchText = searchBar.text! //user input
        searched = true
        
        //MARK: Replace api call
        let replaced = searchText.replacingOccurrences(of: " ", with: "+" )
        let base = "https://api.music.apple.com/v1/catalog/us/search?types=songs&term="
        let final = base + replaced
        
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
            let songInfo = albumName + " - " + name
            let previews = attributes["previews"] as! NSArray  //music audio
            //print("Music Audio: ",previews)
            let audioDic = previews[0] as! NSDictionary //going inside the music preview array
            print(audioDic)
            let musicUrl = audioDic["url"] as! String
            //print(musicUrl)
            self.audios.append(musicUrl)
                
            let songLabel = songInfo
            let genres = attributes["genreNames"] as! NSArray
            self.genreArray = genres
                
            let genreInfo = self.genreArray[0] as! String
                
            DispatchQueue.main.async {
                //STORE THIS
                self.genre = genreInfo
                self.ArtistName = artistName
//              self.genresLabel.backgroundColor = random(colors: myColors)
//              self.genresLabel.layer.masksToBounds = true
//              self.genresLabel.layer.cornerRadius = 8
                self.table.reloadData()
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
                    self.AlbumCover.image = UIImage(data:imagedata! as Data)
                    self.SongInfo = songLabel
                    self.table.reloadData()
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
        table.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.check == 0 {
            startAnimation()
        }
        
        let query = PFQuery(className: "profileInfo") //search this class
        let user = PFUser.current()
        let userID = user!["username"] as! String
        query.whereKey("appleID", equalTo: userID) //search by current user
        query.findObjectsInBackground{(profileInfo, error) in
            if profileInfo != nil{
                //accessing the data inside
                self.userName = profileInfo!
            }
            
            else {
                print("error quering for posts: \(String(describing: error))")
            }
        }
        
        //post button and caption
        caption.isHidden = true
        postButton.isHidden = true
        
        //Keyboard dismisses
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
        //stopAnimation()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    //MARK: SEARCH BAR SELECTOR
    
    @objc func didTapSearchBar() {
        //dropDown.show()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let data = genre
        print(data)
                
        // Create a new variable to store the instance of the SecondViewController
        // set the variable from the SecondViewController that will receive the data
        let destinationVC = segue.destination as! profileViewController
        destinationVC.genre = data
    }
    
}


    

