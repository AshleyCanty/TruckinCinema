//
//  SnackBarSelectedItemsOptionsVC+extensions.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 12/29/23.
//

import Foundation
import UIKit


// MARK: - CollectionView Delegate methods

extension SnackBarSelectedItemOptionsVC {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            return CGSize(width: view.frame.width - (AppTheme.LeadingTrailingMargin*2), height: 150)
        }
        return CGSize(width: view.frame.width - (AppTheme.LeadingTrailingMargin*2), height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item > 0, let cell = collectionView.cellForItem(at: indexPath) as? SnackBarItemOptionCell, let item = cell.item, item.mainMenu == SnackBarItemMain.Popcorn.getStringVal() else { return }
        
        let alertVC = UIAlertController(title: "Which size would you like?", message: nil, preferredStyle: .actionSheet)
        var prices: [String] = []
        
        let (action, _) = setupAlertForSelectedPopcornSnack(index: indexPath.item, item: item)
        alertVC.addAction(action)
        present(alertVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getSnackBarItems().count + 1 // extra one for large cell at top
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SnackBarCell.reuseIdentifier, for: indexPath) as? SnackBarCell {
                cell.type = type
                cell.rightArrowIcon.isHidden = true
                return cell
            }
        } else {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SnackBarItemOptionCell.reuseID, for: indexPath) as? SnackBarItemOptionCell {
                let item = getSnackBarItems()[indexPath.item - 1]
                cell.configure(image: UIImage(imgNamed: item.image), item: item)
                return cell
            }
        }
        
        return SnackBarItemOptionCell()
    }
}
