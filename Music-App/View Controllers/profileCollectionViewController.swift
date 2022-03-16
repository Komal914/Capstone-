//
//  profileCollectionViewController.swift
//  Music-App
//
//  Created by Sumiya Akter on 3/16/22.
//

import UIKit

class profileCollectionViewController: UICollectionViewController {
    
    private let reuseIdentifier = "profileCell"
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(
      top: 50.0,
      left: 10.0,
      bottom: 50.0,
      right: 10.0)

    override func viewDidLoad() {
        super.viewDidLoad()

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
//more layout stuff
extension profileCollectionViewController {
      // 1
      override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
      ) -> Int {
        return 30
      }
      
      // 2
      override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
      ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: reuseIdentifier,
          for: indexPath)
          
        cell.backgroundColor = .systemBlue
          
        // Configure the cell
        return cell
      }
    
    //header config
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            
            guard kind == UICollectionView.elementKindSectionHeader else {
                return UICollectionReusableView()
                //If Footer ^
            }
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: profileHeaderCollectionReusableView.identifier, for: indexPath) as! profileHeaderCollectionReusableView
            return header
        }
    }

    // MARK: UICollectionViewDelegate
// layout of collectionview
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



