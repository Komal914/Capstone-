//
//  HomeViewController.swift
//  Music2
//
//  Created by Komal Kaur on 3/20/22.
//

import UIKit
import Parse
import AVFoundation

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    
    let model = try? genreRecommender();
    var user: User?
    var posts = [PFObject]()
    var aboutToBecomeInvisibleCell = -1
    var visibleIP : IndexPath?
    var currentPostUsername = String()
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //MARK: PARSE: Queries to backend
        let query = PFQuery(className: "posts")
        query.findObjectsInBackground{(posts, error) in
            if posts != nil{
                self.posts = posts! //storing from backend to this file
                var reversePosts = [PFObject]()
                reversePosts = posts!.reversed()
                let first = reversePosts[0]
                self.currentPostUsername = first["username"] as! String
                print(self.currentPostUsername)
                self.table.reloadData()
            }
            
            else {
                print("error quering for posts: \(String(describing: error))")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        table.delegate = self
        table.dataSource = self
   
        // Do any additional setup after loading the view.
        
        visibleIP = IndexPath.init(row: 0, section: 0)
//        let indexPaths = self.table.indexPathsForVisibleRows
//        var cells = [Any]()
//        for ip in indexPaths!{
//            if let HomeCell = self.table.cellForRow(at: ip) as? HomeCell{
//                cells.append(HomeCell)
//            }
//        }
//
//        let firstCell = cells.first as! HomeCell
//        let firstUser = firstCell.usernameButton.currentTitle!
//        print(firstUser)
        
        /*let interactions = NSMutableDictionary();
        interactions["comedy"] = 1;
        interactions["hip hop"] = 1;
        print(interactions)
        
        let modelInput = genreRecommenderInput(interactions: interactions as! [String : Double], k: 1);
        guard let modelOutput = try? model.prediction(input: modelInput) else {
            fatalError("Unexpected runtime error.");
        }
        
        print(modelOutput.probabilities);
        print(modelOutput.recommendations);*/
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //should return number of posts
        return posts.count
    }
    
    @IBAction func homeCommentButton(_ sender: Any) {
        
        performSegue(withIdentifier: "homeComment", sender: self)
        
    }
    
        
    @IBAction func onUsernameButton(_ sender: UIButton) {
        
        performSegue(withIdentifier: "userProfile", sender: self)
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let indexPaths = self.table.indexPathsForVisibleRows
        var cells = [Any]()
        for ip in indexPaths!{
            if let HomeCell = self.table.cellForRow(at: ip) as? HomeCell{
                cells.append(HomeCell)
            }
        }
    
        let cellCount = cells.count
        if cellCount == 0 {return}
        if cellCount == 1{
            if visibleIP != indexPaths?[0]{
                visibleIP = indexPaths?[0]
            }
            if let homeCell = cells.last! as? HomeCell{
                currentPostUsername = self.getUserName(cell: homeCell, indexPath: (indexPaths?.last)!)
                print("POST 0",currentPostUsername)
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
                        print ("visible = \(indexPaths?[i])")
                        if let homeCell = cells[i] as? HomeCell{
                            currentPostUsername = self.getUserName(cell: homeCell, indexPath: (indexPaths?[i])!)
                            print("USERNAMEEEE ", currentPostUsername)
                        }
                    }
                }
        
            }
        }
    }
    
    func getUserName(cell : HomeCell, indexPath : IndexPath) -> String{
        return cell.usernameButton.currentTitle!
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 672 //or whatever you need
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = table.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeCell
        
        var reversePosts = [PFObject]()
        reversePosts = posts.reversed()
        

        let post = reversePosts[indexPath.row]
        
        // songinfo
        cell.albumNameSongName.text = post["song"] as? String
        
        // song cover
        let imageFile = post["cover"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        cell.albumCover.af.setImage(withURL: url)
        
        // caption
        let caption = post["caption"] as! String
        cell.captionFromTheUser.text = caption
        
        // artist name
        cell.artistNameLabel.text = post["artistName"] as? String
        
        // genres
        cell.genreLabel.text = post["genre"] as? String
        cell.genreLabel.layer.masksToBounds = true
        cell.genreLabel.layer.cornerRadius = 8
        
        
        // sound file
        let sound = post["audio"] as! String
        let soundUrl = URL(string: sound)
        //sendng music url to cell class
        cell.videoPlayerItem = AVPlayerItem.init(url: soundUrl!)
        
        
        // username
        if(post["username"] != nil){
            let userName = post["username"] as! String
            cell.usernameButton.setTitle(userName, for: .normal)
            
        }
        
        return cell
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let vc = segue.destination as! userProfileViewController
        vc.name = currentPostUsername
        
    }
    
}
