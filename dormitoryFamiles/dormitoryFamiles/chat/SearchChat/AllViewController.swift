//
//  AllChattingViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/07/13.
//

import UIKit

class AllViewController: UIViewController {
    
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
    
    //데이터 두개만 받아오기
    let chattingRoomData = [
        "code": 200,
        "data": [
            "nowPageNumber": 0,
            "isLast": true,
            "chatRooms": [
                [
                    "roomId": 8,
                    "memberId": 8,
                    "memberNickname": "닉네임8",
                    "unReadCount": 0,
                    "lastMessage": "Hello, how are you?",
                    "lastMessageTime": "2024-05-30T13:58:10"
                ],
                [
                    "roomId": 7,
                    "memberId": 7,
                    "memberNickname": "닉네임7",
                    "memberProfileUrl": "http://t1.kakaocdn.net/account_images/default_profile.jpeg.twg.thumb.R640x640",
                    "unReadCount": 0,
                    "lastMessage": "Hello, how are you?",
                    "lastMessageTime": "2024-05-30T13:57:47"
                ],
                [
                    "roomId": 5,
                    "memberId": 5,
                    "memberNickname": "닉네임5",
                    "memberProfileUrl": "http://t1.kakaocdn.net/account_images/default_profile.jpeg.twg.thumb.R640x640",
                    "unReadCount": 0,
                    "lastMessage": "Hello, how are you?",
                    "lastMessageTime": "2024-05-30T13:57:10"
                ],
                [
                    "roomId": 4,
                    "memberId": 4,
                    "memberNickname": "닉네임4",
                    "memberProfileUrl": "http://t1.kakaocdn.net/account_images/default_profile.jpeg.twg.thumb.R640x640",
                    "unReadCount": 0,
                    "lastMessage": "Hello, how are you?",
                    "lastMessageTime": "2024-05-30T13:56:49"
                ],
                [
                    "roomId": 3,
                    "memberId": 3,
                    "memberNickname": "닉네임3",
                    "memberProfileUrl": "http://t1.kakaocdn.net/account_images/default_profile.jpeg.twg.thumb.R640x640",
                    "unReadCount": 0,
                    "lastMessage": "Hello, how are you?",
                    "lastMessageTime": "2024-05-30T13:56:25"
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
    
    let chattingRoomTabelView: UITableView = {
        let tableView = UITableView()
        tableView.register(ChattingHomeTableViewCell.self, forCellReuseIdentifier: ChattingHomeTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        setTableView()
        addComponents()
        setConstraints()
    }
    
    private func setCollectionView() {
        followingCollectionView.delegate = self
        followingCollectionView.dataSource = self
        
        allDoomzCollectionView.delegate = self
        allDoomzCollectionView.dataSource = self
    }
    
    private func setTableView() {
        chattingRoomTabelView.delegate = self
        chattingRoomTabelView.dataSource = self
    }
    
    private func addComponents() {
        [followingLabelAndButtonStackView, allDoomzLabelAndButtonStackView, chattingRoomLabelAndButtonStackView, messageLabelAndButtonStackView, followingCollectionView, allDoomzCollectionView, chattingRoomTabelView].forEach {
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
        
        allDoomzLabelAndButtonStackView.snp.makeConstraints {
            $0.top.equalTo(followingCollectionView.snp.bottom).inset(-32)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(32)
        }
        
        allDoomzCollectionView.snp.makeConstraints{
            $0.top.equalTo(allDoomzLabelAndButtonStackView.snp.bottom).inset(-12)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(70)
        }
        
        chattingRoomLabelAndButtonStackView.snp.makeConstraints {
            $0.top.equalTo(allDoomzCollectionView.snp.bottom).inset(-32)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(32)
        }
        
        chattingRoomTabelView.snp.makeConstraints {
            $0.top.equalTo(chattingRoomLabelAndButtonStackView.snp.bottom).inset(-12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(146)
        }
    }
}

extension AllViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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

extension AllViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case chattingRoomTabelView:
            let data = chattingRoomData["data"] as! [String: Any]
            let chatRoom = data["chatRooms"] as! [[String: Any]]
            return chatRoom.count
        default:
            return 0
        }
    }
    
    //데이터 두개만 받아오기
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChattingHomeTableViewCell.identifier, for: indexPath) as? ChattingHomeTableViewCell else {
            return UITableViewCell()
        }
        
        if let data = chattingRoomData["data"] as? [String: Any],
           let chatRooms = data["chatRooms"] as? [[String: Any]] {
            let chatData = chatRooms[indexPath.row]
            let memberNickname = chatData["memberNickname"] as? String ?? ""
            let memberProfileUrl = chatData["memberProfileUrl"] as? String ?? ""
            let unReadCount = chatData["unReadCount"] as? Int ?? 0
            let lastMessage = chatData["lastMessage"] as? String ?? ""
            let lastMessageTime = chatData["lastMessageTime"] as? String ?? ""
            
            cell.configure(memberNickname: memberNickname, memberProfileUrl: memberProfileUrl, unReadCount: unReadCount, lastMessage: lastMessage, lastMessageTime: lastMessageTime)
        }
        cell.selectionStyle = .none
        return cell
    }
    
}
