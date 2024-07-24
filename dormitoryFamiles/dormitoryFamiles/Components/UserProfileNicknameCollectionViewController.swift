//
//  UserProfileNicknameCollectionViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/07/14.
//

import UIKit

class UserProfileNicknameCollectionView: UICollectionView {

    init(spacing: CGFloat, scrollDirection: UICollectionView.ScrollDirection) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = scrollDirection
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.itemSize = CGSize(width: 48, height: 70)
        
        super.init(frame: .zero, collectionViewLayout: layout)
        
        self.register(UserProfileNicknameCollectionViewControllerCell.self, forCellWithReuseIdentifier: UserProfileNicknameCollectionViewControllerCell.identifier)
        self.showsHorizontalScrollIndicator = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
