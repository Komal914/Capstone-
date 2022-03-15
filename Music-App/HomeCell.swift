//
//  HomeCell.swift
//  Music-App
//
//  Created by Komal Kaur on 3/14/22.
//

import UIKit

class HomeCell: UITableViewCell {
    
//MARK: OUTLETS
    
    @IBOutlet weak var artistProfilePic: UIImageView!
    
    
    @IBOutlet weak var userProfilePic: UIImageView!
    
    
    @IBOutlet weak var albumCoverPic: UIImageView!
    
    
    @IBOutlet weak var artistNameLabel: UILabel!
    
    
    @IBOutlet weak var albumNameAndSongLabel: UILabel!
    
    
    @IBOutlet weak var userDisplayNameLabel: UILabel!
    
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    @IBOutlet weak var captionFromTheUserLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
