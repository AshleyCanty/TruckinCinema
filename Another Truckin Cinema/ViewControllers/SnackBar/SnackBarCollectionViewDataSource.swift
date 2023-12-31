//
//  SnackBarCollectionViewDataSource.swift
//  Another Truckin Cinema
//
//  Created by ashley canty on 12/28/23.
//

import Foundation
import UIKit


class SnackBarCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    override init() {
        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SnackBarItemType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SnackBarCell.reuseIdentifier, for: indexPath) as? SnackBarCell
        
        let currentType = SnackBarItemType.allCases[indexPath.item]
        cell?.type = currentType
        return cell ?? SnackBarCell()
    }
}
