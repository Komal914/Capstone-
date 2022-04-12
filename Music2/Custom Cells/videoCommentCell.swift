//
//  videoCommentCell.swift
//  Music2
//
//  Created by Komal Kaur on 4/12/22.
//

import UIKit

class videoCommentCell: UITableViewCell {
    
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
