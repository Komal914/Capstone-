//
//  MusicVideosCell.swift
//  Music2
//
//  Created by Komal Kaur on 3/20/22.
//

import UIKit

class MusicVideosCell: UITableViewCell {
    
    @IBOutlet weak var artistNameLabel: UILabel!
    
    @IBOutlet weak var albumNameandSongNameLabel: UILabel!
    
    
    @IBOutlet weak var musicVideoView: UIView!
    
    @IBOutlet weak var likeButton: UIButton!
    
    
    
    @IBOutlet weak var commentButton: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
