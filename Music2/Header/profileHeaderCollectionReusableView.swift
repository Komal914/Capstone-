//
//  profileHeaderCollectionReusableView.swift
//  Music2
//
//  Created by Sumiya Akter on 3/20/22.
//

import UIKit

class profileHeaderCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "profileHeaderCollectionReusableView"
    
    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var postsNumberLabel: UILabel!
    
    @IBOutlet weak var fansLabel: UILabel!
    @IBOutlet weak var fansNumberLabel: UILabel!
    
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followingNumberLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var editButton: UIButton!
}
