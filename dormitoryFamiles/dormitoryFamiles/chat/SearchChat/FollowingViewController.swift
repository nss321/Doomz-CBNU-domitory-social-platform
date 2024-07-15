//
//  FollowingViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/07/15.
//

import UIKit

class FollowingViewController: UIViewController {
    
    let followingSampleData = [
        "code": 200,
        "data": [
            "totalPageNumber": 1,
            "nowPageNumber": 0,
            "isLast": true,
            "memberProfiles": [
                [
                    "memberId": 5,
                    "nickname": "유림잉",
                    "profileUrl": "https://dormitory-family-images-bucket.s3.ap-northeast-2.amazonaws.com/a0345319-feff-4998-b098-b2322261acba_IMG_0338.JPG"
                ],
                [
                    "memberId": 3,
                    "nickname": "해나짱",
                    "profileUrl": "http://k.kakaocdn.net/dn/cTaX1s/btsFAgXr5mH/n2AXHaWczRKt2Fxmt8hJMk/img_640x640.jpg"
                ]
            ]
        ]
    ] as [String : Any]
    
    let followingLabel: UILabel = {
        let label = UILabel()
        label.font = .title2
        label.text = "팔로잉"
        return label
    }()
    
    let followingCollectionView = UserProfileNicknameCollectionView(spacing: 20, scrollDirection: .vertical)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        addComponents()
        setConstraints()
    }
    
    private func setCollectionView() {
        followingCollectionView.delegate = self
        followingCollectionView.dataSource = self
    }
    
    private func addComponents() {
        [followingLabel, followingCollectionView].forEach {
            view.addSubview($0)
        }
    }
    
    private func setConstraints() {
        followingLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(66)
            $0.leading.equalToSuperview().inset(25)
            $0.height.equalTo(32)
        }
        
        followingCollectionView.snp.makeConstraints{
            $0.top.equalTo(followingLabel.snp.bottom).inset(-12)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(-20)
        }
    }
    
}
extension FollowingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let data = followingSampleData["data"] as! [String: Any]
        let profiles = data["memberProfiles"] as! [[String: Any]]
        return profiles.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProfileNicknameCollectionViewControllerCell.identifier, for: indexPath) as? UserProfileNicknameCollectionViewControllerCell else {
            fatalError()
        }
        var profile: [String: Any] = [:]
        let data = followingSampleData["data"] as! [String: Any]
        let profiles = data["memberProfiles"] as! [[String: Any]]
        profile = profiles[indexPath.row]
        let nickname = profile["nickname"] as! String
        let profileUrl = profile["profileUrl"] as! String
        cell.configure(text: nickname, profileUrl: profileUrl)
        
        return cell
    }
}
    
