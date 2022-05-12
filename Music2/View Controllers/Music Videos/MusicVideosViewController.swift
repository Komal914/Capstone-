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
        
        let terms = ["billie", "pop", "doja", "bad", "chainsmoakers", "impala", "kendrick", "future", "cardi", "baby", "lil", "glass"]
        
        func random(terms: [String]) -> String {
            return terms[Int(arc4random_uniform(UInt32(terms.count)))]
        }
        
        let term = random(terms: terms)
        print("MYYYYYYY TERM", term )
        
        let replaced = term
        let base = "https://api.music.apple.com/v1/catalog/us/search?types=music-videos&term="
        let final = base + replaced

        
        
//        let url = URL(string:"https://api.music.apple.com/v1/catalog/us/music-videos?ids=1553279848,1549013065")!
        
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
                let musicVideos = data["music-videos"] as! NSDictionary
                let data2 = musicVideos["data"] as! NSArray
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
        //print("center point - \(center)")
        //print("centerIndex - \(centerIndex.row)")
        let autoPlayCell = table.cellForRow(at: centerIndex) as? MusicVideosCell
        autoPlayCell?.startPlayback()
    }
    

//MARK: TABLE FUNCTIONS
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 700          //or whatever you need
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        //should return .count of the number of music videos
        return videoData.count/2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "MusicVideosCell") as! MusicVideosCell
        
                
        let video = videoData[indexPath.row] as! NSDictionary        //each video data
        print("VIDEOOOOOOOOOOOOOO")
        print(video)
        
        let attributes = video["attributes"] as! NSDictionary
        //attributes for each video
//        print("atttributes")
//        print(attributes)
        let artistName = attributes["artistName"] as! String
        print("NAAAAME", artistName)
        cell.artistNameLabel.text = artistName
        
        let previews = attributes["previews"] as! NSArray

        //let albumName = array["albumName"] as! String
        let name = attributes["name"] as! String
//        //currentVideo = name
//        let previews = attributes["previews"] as! NSArray
        let artwork = previews[0] as! NSDictionary
        let musicVideoUrl = artwork["url"] as! String
        print("URL")
        print(musicVideoUrl)
//        let artistName = attributes["artistName"] as! String
        cell.artistNameLabel!.text = artistName
        cell.albumNameandSongNameLabel!.text = name
        let videoURL = URL(string: musicVideoUrl)                   //turn string into URL

        self.videoURLs.append(videoURL!)
//
//        //print(videoURLs)
        cell.videoPlayerItem = AVPlayerItem.init(url: videoURLs[indexPath.row % 2])
        return cell
    }
    
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
                else{
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
        //print("end = \(indexPath)")
        if let videoCell = cell as? MusicVideosCell {
            videoCell.stopPlayback()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchText = searchBar.text! //user input
        print(searchText)
        
//        //MARK: Replace api call
//        let replaced = searchText.replacingOccurrences(of: " ", with: "+" )
//        let base = "https://api.music.apple.com/v1/catalog/us/search?types=songs&term="
//        let final = base + replaced
//
//        let developerToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiIsImtpZCI6IjQ1OVlDU0NWN04ifQ.eyJpc3MiOiI0VlMzWEFQWFRWIiwiZXhwIjoxNjYzNTcyNzMzLCJpYXQiOjE2NDc4MDQ3MzN9.J-jb_NnC82o7oSlFvLt84mf7AkNJ3o8Fhhld4ADIDmgY6NfUBVprpD7y1yqX3pjtIUFI85RDxE2yKS12TFmVuA"
//
//
//        let url = URL(string: final)!
//
//        var request = URLRequest(url: url)
//        request.setValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")
//
//        let session = URLSession.shared
//        let task = session.dataTask(with: request) {(data, response, error) in
//        guard let data = data else {
//                return
//        }
//
//        do {
//            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//            self.songData = json?["results"] as! NSDictionary
//            let songs = self.songData["songs"] as! NSDictionary
//            let numberOfSongs = songs["data"] as! NSArray
//
////MARK: ONE SONG DATA
//            let firstSong = numberOfSongs[0] as! NSDictionary
//            // print(firstSong) api data for one song
//            let attributes = firstSong["attributes"] as! NSDictionary
//            let artWork = attributes["artwork"] as! NSDictionary
//            let name = attributes["name"] as! String
//            let artistName = attributes["artistName"] as! String
//
//            self.songMenu.append(name)
//
////MARK: DROPDOWN DATASOURCE
//            self.dropDown.dataSource = self.songMenu
//            let albumName = attributes["albumName"] as! String
//            let songInfo = albumName + " - " + name
//            let previews = attributes["previews"] as! NSArray  //music audio
//            //print("Music Audio: ",previews)
//            let audioDic = previews[0] as! NSDictionary //going inside the music preview array
//            print(audioDic)
//            let musicUrl = audioDic["url"] as! String
//            //print(musicUrl)
//            self.audios.append(musicUrl)
//
//            let songLabel = songInfo
//            let genres = attributes["genreNames"] as! NSArray
//            self.genre = genres
//
//            let genreInfo = self.genre[0] as! String
//
//            DispatchQueue.main.async {
//                //STORE THIS
//                self.Genre = genreInfo
//                self.ArtistName = artistName
////              self.genresLabel.backgroundColor = random(colors: myColors)
////              self.genresLabel.layer.masksToBounds = true
////              self.genresLabel.layer.cornerRadius = 8
//                self.table.reloadData()
            }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        let center = CGPoint(x: table.center.x + table.contentOffset.x,y: table.center.y + table.contentOffset.y)
        
        guard let centerIndex = self.table.indexPathForRow(at: center) else {return}
        //print("center point - \(center)")
        //print("centerIndex - \(centerIndex.row)")
        let autoPlayCell = table.cellForRow(at: centerIndex) as? MusicVideosCell
        autoPlayCell?.stopPlayback()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "musicCommentSegue") {
            let vc = segue.destination as! videoCommentsViewController
            vc.videoInfo = currentVideo
            
        }
        
        
    }
}
