//
//  CommentCollectionViewCell.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/02/18.
//

import UIKit

class CommentCollectionViewCell: UICollectionViewCell {
   
    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "CommentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "relpyCell")
    }

}

extension CommentCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 2
        }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "relpyCell", for: indexPath) as UICollectionViewCell
           return cell
       }

}

extension CommentCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.bounds.width
        let height: CGFloat = 100
        
        return CGSize(width: width, height: height)
    }
    
    //셀과 셀 사이의 간격.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
}
