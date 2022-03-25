//
//  profileViewController.swift
//  Music2
//
//  Created by Sumiya Akter on 3/25/22.
//

import UIKit

class profileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var genreCollectionView: UICollectionView!
    @IBOutlet weak var postsCollectionView: UICollectionView!
    
    
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(
        top: 40.0,
        left: 10.0,
        bottom: 40.0,
        right: 10.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        let layout = genreCollectionView.collectionViewLayout as? UICollectionViewFlowLayout // casting is required because UICollectionViewLayout doesn't offer header pin. Its feature of UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        

        // Do any additional setup after loading the view.
    }
        
}

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

// MARK: UICollectionViewDataSource
extension profileViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (collectionView == genreCollectionView)
        {
            return 10
        }
        
        return 30
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = postsCollectionView.dequeueReusableCell(withReuseIdentifier: "postsCollectionViewCell", for: indexPath) as! postsCollectionViewCell
        cell.backgroundColor = .systemBlue
        
        if (collectionView == genreCollectionView)
        {
            let cell2 = genreCollectionView.dequeueReusableCell(withReuseIdentifier: "genreCollectionViewCell", for: indexPath) as! genreCollectionViewCell
            cell2.backgroundColor = .cyan
            return cell2
        }

        // Configure the cell

        return cell
    }
    
     func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch kind {
            // 1
        case UICollectionView.elementKindSectionHeader:
            // 2
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "\(profileHeaderCollectionReusableView.self)",
                for: indexPath)
            
            // 3
            guard let typedHeaderView = headerView as? profileHeaderCollectionReusableView
            else { return headerView }
            
            // 4
            //let searchTerm = searches[indexPath.section].searchTerm
            //typedHeaderView.titleLabel.text = searchTerm
            return typedHeaderView
        default:
            // 5
            assert(false, "Invalid element type")
        }
    }
}

// MARK: UICollectionViewDelegate

extension profileViewController: UICollectionViewDelegateFlowLayout {
    // 1
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        // 2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    // 3
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        
        return sectionInsets.left
    }
}
