//
//  MusicVideosViewController.swift
//  Music2
//
//  Created by Komal Kaur on 3/20/22.
//

import UIKit
import StoreKit
import MediaPlayer
import AVFoundation


class MusicVideosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var aboutToBecomeInvisibleCell = -1
    var avPlayerLayer: AVPlayerLayer!
    var videoURLs = Array<URL>()
    var firstLoad = true
    var visibleIP : IndexPath?
    var currentVideo = String()
    var searchText = " "
    
    var videoData = NSArray()
    var filteredVideoData = [[String: Any?]]()
    
//MARK: OUTLETS
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
   
    
    
    
    
    @IBAction func commentsButton(_ sender: Any) {
        performSegue(withIdentifier: "musicCommentSegue", sender: self)
    }

    //MARK: VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBar.isHidden = true
        
        table.delegate = self
        table.dataSource = self
        searchBar.delegate = self
        visibleIP = IndexPath.init(row: 0, section: 0)
        //dismiss keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    //MARK: API REQUEST
        //store front
        let controller = SKCloudServiceController()
        controller.requestStorefrontCountryCode { countryCode, error in
            // Use the value in countryCode for subsequent API requests
            if #available(iOS 15.0, *) {
                //print("Storyboard:", Storefront.self)
                print(countryCode!)
            }
            
            else {
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
        
        let terms = ["billie", "pop", "doja", "bad", "chainsmokers", "impala", "kendrick", "future", "cardi", "baby", "lil", "glass", "weeknd", "ariana", "ed", "jay-z", "miley", "katy", "drake", "justin", "post", "j-cole", "juice", "nicki", "keshi", "070", "Asap", "willow", "avicii", "boogie", "hwa+sa"]
        
        func random(terms: [String]) -> String {
            return terms[Int(arc4random_uniform(UInt32(terms.count)))]
        }
        
        let term = random(terms: terms)
        print("MYYYYYYY TERM", term )
        
        let replaced = term
        let base = "https://api.music.apple.com/v1/catalog/us/search?types=music-videos&term="
        let final = base + replaced
        
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
                print("MY DATA")
                let data = json?["results"] as! NSDictionary
                if(data["music-videos"] == nil){
                    return
                }
                let musicVideos = data["music-videos"] as! NSDictionary
                let data2 = musicVideos["data"] as! NSArray
                print(data)
                let count = data2.count
                print("COUUUUUUUNT")
                print(count)
                self.videoData = data2
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
            }
            
            catch {
            }
        }
        task.resume()
        table.reloadData()
    }
    
//MARK: VIEWDIDAPPEAR
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(true)

        let center = CGPoint(x: table.center.x + table.contentOffset.x,y: table.center.y + table.contentOffset.y)
        
        guard let centerIndex = self.table.indexPathForRow(at: center) else {return}
        let autoPlayCell = table.cellForRow(at: centerIndex) as? MusicVideosCell
        autoPlayCell?.startPlayback()
    }
    

//MARK: TABLE FUNCTIONS
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600       //or whatever you need
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        //should return .count of the number of music videos
        return videoData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("**************************************************")
        //print("INDEX BEFORE:")
        //print(indexPath.row)
        //print("**************************************************")
        let cell = table.dequeueReusableCell(withIdentifier: "MusicVideosCell") as! MusicVideosCell

        let video = videoData[indexPath.row] as! NSDictionary     //each video data
        let attributes = video["attributes"] as! NSDictionary
        let artistName = attributes["artistName"] as! String
        let genre = attributes["genreNames"] as! NSArray
        let actualG = genre[0] as! String
        cell.artistNameLabel.text = artistName
        cell.genreLabel.text = actualG
        cell.genreLabel.layer.masksToBounds = true
        cell.genreLabel.layer.cornerRadius = 8
        let pink = UIColor(red: 0.91, green: 0.27, blue: 0.62, alpha: 1.00)
        cell.genreLabel.backgroundColor = pink
        
        let previews = attributes["previews"] as! NSArray
        let name = attributes["name"] as! String
        let link = attributes["url"] as! String
        let releaseDate = attributes["releaseDate"] as! String
        cell.dateLabel.text = "Release Date: " + releaseDate
        cell.moreInfo.text = "More info: " + link
        let artwork = previews[0] as! NSDictionary
        let musicVideoUrl = artwork["url"] as! String
        cell.artistNameLabel!.text = artistName
        cell.albumNameandSongNameLabel!.text = name
        let videoURL = URL(string: musicVideoUrl) //turn string into URL
        self.videoURLs.append(videoURL!)
        //print(self.videoURLs)
        //print("COUNT:", self.videoURLs.count)
        //print("INDEX:", indexPath.row)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//           cell.videoPlayerItem = AVPlayerItem.init(url: self.videoURLs[indexPath.row])
//        }
        cell.videoPlayerItem = AVPlayerItem.init(url: videoURLs[indexPath.row])
        return cell
    }
    
    //need to add the video urls in a func, loop videos and call the func once needed only
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let indexPaths = self.table.indexPathsForVisibleRows
        var cells = [Any]()
        for ip in indexPaths!{
            if let videoCell = self.table.cellForRow(at: ip) as? MusicVideosCell{
                cells.append(videoCell)
            }
        }
    
        let cellCount = cells.count
        if cellCount == 0 {return}
        if cellCount == 1{
            if visibleIP != indexPaths?[0]{
                visibleIP = indexPaths?[0]
            }
            if let videoCell = cells.last! as? MusicVideosCell{
                self.playVideoOnTheCell(cell: videoCell, indexPath: (indexPaths?.last)!)
                currentVideo = self.getCurrentVideo(cell: videoCell, indexPath: (indexPaths?.last)!)
                print("pls get video", currentVideo)
            }
        }
    
        if cellCount >= 2 {
            for i in 0..<cellCount{
                let cellRect = self.table.rectForRow(at: (indexPaths?[i])!)
                let intersect = cellRect.intersection(self.table.bounds)

                // curerntHeight is the height of the cell that is visible
                let currentHeight = intersect.height
                //print("\n \(currentHeight)")
                let cellHeight = (cells[i] as AnyObject).frame.size.height
                
                // 0.95 here denotes how much you want the cell to display for it to mark itself as visible, .95 denotes 95 percent, you can change the values accordingly
                if currentHeight > (cellHeight * 0.95){
                    if visibleIP != indexPaths?[i]{
                        visibleIP = indexPaths?[i]
                        //print ("visible = \(indexPaths?[i])")
                        if let videoCell = cells[i] as? MusicVideosCell{
                            self.playVideoOnTheCell(cell: videoCell, indexPath: (indexPaths?[i])!)
                            currentVideo = self.getCurrentVideo(cell: videoCell, indexPath: (indexPaths?[i])!)
                            print("pls get video part 2", currentVideo)

                        }
                    }
                }
                
                else {
                    if aboutToBecomeInvisibleCell != indexPaths?[i].row{
                        aboutToBecomeInvisibleCell = (indexPaths?[i].row)!
                        if let videoCell = cells[i] as? MusicVideosCell{
                            self.stopPlayBack(cell: videoCell, indexPath: (indexPaths?[i])!)
                        }
                    }
                }
            }
        }
    }
    
    func getCurrentVideo(cell: MusicVideosCell, indexPath: IndexPath) -> String {
        return cell.albumNameandSongNameLabel.text!
    }
    
    func playVideoOnTheCell(cell : MusicVideosCell, indexPath : IndexPath){
            cell.startPlayback()
    }

        func stopPlayBack(cell : MusicVideosCell, indexPath : IndexPath){
            cell.stopPlayback()
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let videoCell = cell as? MusicVideosCell {
            videoCell.stopPlayback()
        }
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.videoURLs.removeAll() //i need to remove them so the table reload can add the new data
        print("Emptied")
        print(self.videoURLs)
        
        //MARK: HELP 
       
        for video in videoData {
            if videoData.count != 0 {
                videoData.dropFirst()
                print("dropped")
            }
        }
        
        print(self.videoData)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        searchText = searchBar.text! //user input
        print(searchText)
        
        //MARK: Replace api call
        let replaced = searchText.replacingOccurrences(of: " ", with: "+" )
        let base = "https://api.music.apple.com/v1/catalog/us/search?types=music-videos&term="
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
                if (json?["results"] == nil){
                    print("i am empty")
                    return
                }
                let data = json?["results"] as! NSDictionary
                let musicVideos = data["music-videos"] as! NSDictionary
                let data2 = musicVideos["data"] as! NSArray
                let datacount = data2.count
                print("################################################################")
                print("")
                print("")
                print("")
                print("COUNT", datacount)
                print("###############################################################")
                
                self.videoData = data2
//                DispatchQueue.main.async {
//                    self.table.reloadData()
//                }
            }
            
            catch {
                //error
            }
        }
        task.resume()
        table.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        let center = CGPoint(x: table.center.x + table.contentOffset.x,y: table.center.y + table.contentOffset.y)
        
        guard let centerIndex = self.table.indexPathForRow(at: center) else {return}
        let autoPlayCell = table.cellForRow(at: centerIndex) as? MusicVideosCell
        autoPlayCell?.stopPlayback()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "musicCommentSegue") {
            let vc = segue.destination as! videoCommentsViewController
            vc.videoInfo = currentVideo
        }
    }
}
