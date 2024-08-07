//
//  UICollectionView+.swift
//  dormitoryFamiles
//
//  Created by BAE on 7/24/24.
//

import UIKit

extension UICollectionViewDelegateFlowLayout {
    func handleSelection(collectionView: UICollectionView, indexPath: IndexPath, selectedValue: inout String?, items: [String]) {
        if let currentValue = selectedValue, let selectedIndex = items.firstIndex(of: currentValue) {
            if selectedIndex == indexPath.row {
                selectedValue = nil
                collectionView.deselectItem(at: indexPath, animated: false)
            } else {
                let previousIndexPath = IndexPath(item: selectedIndex, section: 0)
                collectionView.deselectItem(at: previousIndexPath, animated: false)
                selectedValue = items[indexPath.row]
            }
        } else {
            selectedValue = items[indexPath.row]
        }
    }
}
