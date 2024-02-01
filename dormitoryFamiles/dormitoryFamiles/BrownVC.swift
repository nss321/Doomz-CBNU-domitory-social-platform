//
//  BrownVC.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/01/31.
//

import UIKit

class BrownVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDelegate()
        self.collectionView.register(UINib(nibName: "BulluetinBoardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")

        collectionView.register(UINib(nibName: "PopularCollectionViewHeader",
                                      bundle: nil),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "header")

    }
    
        private func setDelegate() {
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
        }
    


}

extension BrownVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 99
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor(red: 0.894, green: 0.898, blue: 0.906, alpha: 1).cgColor

        cell.layer.cornerRadius = 20

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 335, height: 167)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }

    // 헤더의 크기를 지정하는 함수
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 10, height: 56)
    }

    // 헤더를 생성하는 함수
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
            // headerView 설정 코드를 여기에 작성하세요

            return headerView
        default:
            assert(false, "Invalid element type")
        }
    }

}
