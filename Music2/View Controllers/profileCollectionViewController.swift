//
//  profileCollectionViewController.swift
//  Music2
//
//  Created by Sumiya Akter on 3/20/22.
//

import UIKit

class profileCollectionViewController: UICollectionViewController {
    
    private let reuseIdentifier = "profileCollectionViewCell"
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(
      top: 50.0,
      left: 10.0,
      bottom: 50.0,
      right: 10.0)


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Profile"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

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
extension profileCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 30
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        cell.backgroundColor = .systemBlue
    
        // Configure the cell
    
        return cell
    }
    
    override func collectionView(
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

extension profileCollectionViewController: UICollectionViewDelegateFlowLayout {
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

    
