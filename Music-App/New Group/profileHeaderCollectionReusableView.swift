//
//  profileHeaderCollectionReusableView.swift
//  Music-App
//
//  Created by Sumiya Akter on 3/16/22.
//

import UIKit

class profileHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "profileHeaderCollectionReusableView"
        
    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var postsNumberLabel: UILabel!
    
    @IBOutlet weak var fanLabel: UILabel!
    @IBOutlet weak var fanNumberLabel: UILabel!
    
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followingNumberLabel: UILabel!
    
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
}
