//
//  MusicVideosCell.swift
//  Music-App
//
//  Created by Komal Kaur on 3/15/22.
//

import UIKit

class MusicVideosCell: UITableViewCell {
    
//MARK: OUTLETS
    
    
    @IBOutlet weak var artistNameLabel: UILabel!
    
    @IBOutlet weak var albumNameandSongNameLabel: UILabel!
    
    
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
