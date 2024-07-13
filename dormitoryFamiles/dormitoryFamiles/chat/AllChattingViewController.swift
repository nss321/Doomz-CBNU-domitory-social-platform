//
//  AllChattingViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/07/13.
//

import UIKit

class AllChattingViewController: UIViewController {
    
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
    
    let allDoomzData = [
        "code": 200,
        "data": [
            "totalPageNumber": 1,
            "nowPageNumber": 0,
            "isLast": true,
            "memberProfiles": [
                [
                    "memberId": 6,
                    "nickname": "닉네임6",
                    "profileUrl": "http://t1.kakaocdn.net/account_images/default_profile.jpeg.twg.thumb.R640x640",
                    "isFollowing": true
                ],
                [
                    "memberId": 5,
                    "nickname": "닉네임5",
                    "profileUrl": "http://t1.kakaocdn.net/account_images/default_profile.jpeg.twg.thumb.R640x640",
                    "isFollowing": true
                ],
                [
                    "memberId": 3,
                    "nickname": "닉네임3",
                    "profileUrl": "http://t1.kakaocdn.net/account_images/default_profile.jpeg.twg.thumb.R640x640",
                    "isFollowing": true
                ],
                [
                    "memberId": 2,
                    "nickname": "닉네임2",
                    "profileUrl": "http://t1.kakaocdn.net/account_images/default_profile.jpeg.twg.thumb.R640x640",
                    "isFollowing": false
                ]
            ]
        ]
    ] as [String : Any]
    
    let followingLabelAndButtonStackView = LabelAndRoundButtonStackView(labelText: "팔로잉", textFont: .title2 ?? UIFont(), buttonText: "더보기", buttonHasArrow: true)
    
    let allDoomzLabelAndButtonStackView = LabelAndRoundButtonStackView(labelText: "전체둠즈", textFont: .title2 ?? UIFont(), buttonText: "더보기", buttonHasArrow: true)
    
    let chattingRoomLabelAndButtonStackView = LabelAndRoundButtonStackView(labelText: "채팅방", textFont: .title2 ?? UIFont(), buttonText: "더보기", buttonHasArrow: true)
    
    let messageLabelAndButtonStackView = LabelAndRoundButtonStackView(labelText: "메세지", textFont: .title2 ?? UIFont(), buttonText: "더보기", buttonHasArrow: true)
    
    let followingCollectionView = UserProfileNicknameCollectionView(spacing: 20, scrollDirection: .horizontal)
    
    let allDoomzCollectionView = UserProfileNicknameCollectionView(spacing: 20, scrollDirection: .horizontal)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        addComponents()
        setConstraints()
    }
    
    private func setCollectionView() {
        
        followingCollectionView.delegate = self
        followingCollectionView.dataSource = self
        
        allDoomzCollectionView.delegate = self
        allDoomzCollectionView.dataSource = self
    }
    
    private func addComponents() {
        [followingLabelAndButtonStackView, allDoomzLabelAndButtonStackView, chattingRoomLabelAndButtonStackView, messageLabelAndButtonStackView, followingCollectionView, allDoomzCollectionView].forEach {
            view.addSubview($0)
        }
    }
    
    private func setConstraints() {
        followingLabelAndButtonStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(66)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(32)
        }
        
        followingCollectionView.snp.makeConstraints{
            $0.top.equalTo(followingLabelAndButtonStackView.snp.bottom).inset(-12)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(70)
        }
    }
}

extension AllChattingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case followingCollectionView:
            let data = followingSampleData["data"] as! [String: Any]
            let profiles = data["memberProfiles"] as! [[String: Any]]
            return profiles.count
        case allDoomzCollectionView:
            let data = allDoomzData["data"] as! [String: Any]
            let profiles = data["memberProfiles"] as! [[String: Any]]
            return profiles.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProfileNicknameCollectionViewControllerCell.identifier, for: indexPath) as? UserProfileNicknameCollectionViewControllerCell else {
            fatalError()
        }
        
        var profile: [String: Any] = [:]
        
        switch collectionView {
        case followingCollectionView:
            let data = followingSampleData["data"] as! [String: Any]
            let profiles = data["memberProfiles"] as! [[String: Any]]
            profile = profiles[indexPath.row]
        case allDoomzCollectionView:
            let data = allDoomzData["data"] as! [String: Any]
            let profiles = data["memberProfiles"] as! [[String: Any]]
            profile = profiles[indexPath.row]
        default:
            break
        }
        
        let nickname = profile["nickname"] as! String
        let profileUrl = profile["profileUrl"] as! String
        cell.configure(text: nickname, profileUrl: profileUrl)
        
        return cell
    }
    
}
