//
//  HomeCell.swift
//  Music2
//
//  Created by Komal Kaur on 3/20/22.
//

import UIKit

class HomeCell: UITableViewCell {
    
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var albumNameSongName: UILabel!
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var captionFromTheUser: UILabel!
    
    @IBAction func likeButton(_ sender: Any) {
    }
    
    
    @IBAction func commentButton(_ sender: Any) {
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
