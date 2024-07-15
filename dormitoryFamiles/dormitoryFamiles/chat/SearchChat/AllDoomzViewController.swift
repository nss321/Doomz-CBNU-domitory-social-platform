//
//  AllDoomzViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/07/15.
//

import UIKit

class AllDoomzViewController: UIViewController {
    let allDoomzData = [
        "code": 200,
        "data": [
            "memberProfiles": [
                [
                    "memberId": 2,
                    "nickname": "닉네임2",
                    "profileUrl": "http://t1.kakaocdn.net/account_images/default_profile.jpeg.twg.thumb.R640x640"
                ],
                [
                    "memberId": 8,
                    "nickname": "닉네임8",
                    "profileUrl": "http://t1.kakaocdn.net/account_images/default_profile.jpeg.twg.thumb.R640x640"
                ]
            ]
        ]
    ] as [String : Any]
    
    let allDoomzLabel: UILabel = {
        let label = UILabel()
        label.font = .title2
        label.text = "전체 둠즈"
        return label
    }()
    
    let allDoomzCollectionView = UserProfileNicknameCollectionView(spacing: 20, scrollDirection: .vertical)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        addComponents()
        setConstraints()
    }
    
    private func setCollectionView() {
        allDoomzCollectionView.delegate = self
        allDoomzCollectionView.dataSource = self
    }
    
    private func addComponents() {
        [allDoomzLabel, allDoomzCollectionView].forEach {
            view.addSubview($0)
        }
    }
    
    private func setConstraints() {
        allDoomzLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(66)
            $0.leading.equalToSuperview().inset(25)
            $0.height.equalTo(32)
        }
        
        allDoomzCollectionView.snp.makeConstraints{
            $0.top.equalTo(allDoomzLabel.snp.bottom).inset(-12)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(-20)
        }
    }
    
}
extension AllDoomzViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let data = allDoomzData["data"] as! [String: Any]
        let profiles = data["memberProfiles"] as! [[String: Any]]
        return profiles.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProfileNicknameCollectionViewControllerCell.identifier, for: indexPath) as? UserProfileNicknameCollectionViewControllerCell else {
            fatalError()
        }
        var profile: [String: Any] = [:]
        let data = allDoomzData["data"] as! [String: Any]
        let profiles = data["memberProfiles"] as! [[String: Any]]
        profile = profiles[indexPath.row]
        let nickname = profile["nickname"] as! String
        let profileUrl = profile["profileUrl"] as! String
        cell.configure(text: nickname, profileUrl: profileUrl)
        
        return cell
    }
}
    
