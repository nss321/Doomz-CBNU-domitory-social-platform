//
//  bulletinBoardMainViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/01/01.
//

import UIKit

class BulletinBoardMainViewController: UIViewController {
    let cellIdentifier = "BulletinBoardMainTableViewCell"
    let tagScrollView = TagScrollView()
    var tags = ["최신순", "모집중"]
    @IBOutlet weak var naviCustomView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        
        setTag()
        getTagMakeButton()
        setDelegate()
        self.collectionView.register(UINib(nibName: "BulluetinBoardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setTag() {
        //네비게이션
        let popularButton = TagButton(title: "인기순")
        tagScrollView.tagStackView.addArrangedSubview(popularButton)
        tagLayout()
        popularButton.addTarget(nil, action: #selector(categoryButtonTapped), for: .touchUpInside)
        categoryButtonTapped(popularButton)
    }
    
    private func setDelegate() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    
    private func tagLayout() {
        self.view.addSubview(tagScrollView)
        tagScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let height: CGFloat = self.view.frame.height
        let width: CGFloat = self.view.frame.width
        let figmaHeight: CGFloat = 852
        let figmaWidth: CGFloat = 391
        let heightRatio: CGFloat = height/figmaHeight
        let widthRatio: CGFloat = width/figmaWidth
        NSLayoutConstraint.activate([
            tagScrollView.bottomAnchor.constraint(equalTo: self.naviCustomView.bottomAnchor, constant: -10*heightRatio),
            tagScrollView.leadingAnchor.constraint(equalTo: self.naviCustomView.leadingAnchor, constant: 16*widthRatio),
            tagScrollView.trailingAnchor.constraint(equalTo: self.naviCustomView.trailingAnchor, constant: -16*widthRatio),
            tagScrollView.heightAnchor.constraint(equalToConstant: 32*heightRatio)
        ])
    }
    
    private func makeButton(tag: String)  {
        let tagButton = TagButton(title: tag)
        tagScrollView.tagStackView.addArrangedSubview(tagButton)
        tagButton.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
        tagButton.tag = 4
    }
    
    @objc private func categoryButtonTapped(_ sender: TagButton) {
        
        //(버튼)활성화UI를 비활성화UI로
        for case let button as TagButton in tagScrollView.tagStackView.arrangedSubviews{
            button.changeWhiteColor()
            button.changeTitleGray()
            button.setTitleColor(.gray4, for: .normal)
            button.layer.borderWidth = 1
            
            //TODO: 여기를 왜 label을 덮은것처럼 색상을 바꿔야하는지 정말 모르겠다. 알아보자 꼭.
            for view in button.subviews {
                if let label = view as? UILabel {
                    label.textColor = .gray4
                }
            }
        }
        
        //(버튼)비활성화UI를 활성화UI로
        sender.changePinkColor()
        sender.setTitleColor(UIColor.white, for: .normal)
        //TODO: 여기를 왜 label을 덮은것처럼 색상을 바꿔야하는지 정말 모르겠다. 알아보자 꼭.
        for view in sender.subviews {
            if let label = view as? UILabel {
                label.textColor = .white
            }
        }
        sender.layer.borderWidth = 0
    }
    
    private func getTagMakeButton() {
        //찜했던 상품들이 해당하는 카테고리를 버튼으로 만듬
        tags.forEach { tag in
            self.makeButton(tag: tag)
        }
    }
}

extension BulletinBoardMainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        return 20
    }
    
}
