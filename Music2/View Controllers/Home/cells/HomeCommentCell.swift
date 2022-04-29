//
//  HomeCommentCell.swift
//  Music2
//
//  Created by Amogh Kalyan on 4/28/22.
//

import UIKit

class HomeCommentCell: UITableViewCell {

    @IBOutlet var homeCommentsUsername: UILabel!
    @IBOutlet var homeComment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
