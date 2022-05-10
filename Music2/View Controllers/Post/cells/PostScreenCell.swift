//
//  PostScreenCell.swift
//  Music2
//
//  Created by Komal Kaur on 4/22/22.
//

import UIKit
import Parse

class PostScreenCell: UITableViewCell {
    var userName = [PFObject]()
  
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var songInfo: UILabel!
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var genres: UILabel!
    
    //MARK: GENRE STUFF
    func random(colors: [UIColor]) -> UIColor {
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
        return colors[Int(arc4random_uniform(UInt32(myColors.count)))]
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
