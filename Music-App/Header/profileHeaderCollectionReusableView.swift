//
//  profileHeaderCollectionReusableView.swift
//  Music-App
//
//  Created by Sumiya Akter on 3/15/22.
//

import UIKit

class profileHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "profileHeaderCollectionReusableView"
    
    @IBOutlet weak var genreLabel: UILabel!
    
    @IBOutlet weak var postsNumberLabel: UILabel!
    @IBOutlet weak var postsLabel: UILabel!
    
    @IBOutlet weak var followerNumberLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    
    @IBOutlet weak var followingNumberLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
}
