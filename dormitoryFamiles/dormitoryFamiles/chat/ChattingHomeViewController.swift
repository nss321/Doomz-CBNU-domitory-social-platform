//
//  chattingHomeViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/07/12.
//

import UIKit
import SnapKit

class ChattingHomeViewController: UIViewController {
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
    
    let sampleChatting = [["roomId": 8,
                           "memberId": 8,
                           "memberNickname": "닉네임8",
                           "unReadCount": 1,
                           "lastMessage": "Hello, how are you?",
                           "lastMessageTime": "2024-05-30T13:58:10"
                          ],
                          [
                            "roomId": 7,
                            "memberId": 7,
                            "memberNickname": "닉네임7",
                            "memberProfileUrl": "http://t1.kakaocdn.net/account_images/default_profile.jpeg.twg.thumb.R640x640",
                            "unReadCount": 20,
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
                          ]]
    
    let followingLabelButtonStackView = LabelAndRoundButtonStackView(labelText: "팔로잉", textFont: .title2 ?? UIFont(), buttonText: "전체보기", buttonHasArrow: true)
    
    private let collectionView = UserProfileNicknameCollectionView(spacing: 12, scrollDirection: .horizontal)
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ChattingHomeTableViewCell.self, forCellReuseIdentifier: ChattingHomeTableViewCell.identifier)
        return tableView
    }()
    
    private let baseLine: UIView = {
        let view = UIView()
        view.backgroundColor = .gray2
        return view
    }()
    
    private let chattingListLabel: UILabel = {
        let label = UILabel()
        label.font = .title2
        label.text = "채팅목록"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setCollectionView()
        setTableView()
        setConstraints()
    }
    
    private func setNavigationBar() {
        self.navigationItem.title = "채팅"
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.head1,
            .foregroundColor: UIColor.doomzBlack
        ]
        self.navigationController?.navigationBar.titleTextAttributes = titleAttributes
        
        let chatSearchImage = UIImage(named: "chatSearch")?.withRenderingMode(.alwaysOriginal)
        let logoImage = UIImage(named: "bulletinBoardLogo")?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: chatSearchImage, style: .plain, target: self, action: #selector(searchButtonTapped))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: logoImage, style: .plain, target: self, action: #selector(logoButtonTapped))
    }
    
    @objc func searchButtonTapped() {
        self.navigationController?.pushViewController(SearchChattingViewController(), animated: true)
    }
    
    @objc func logoButtonTapped() {
        print("로고 버튼 눌림")
    }
    
    private func setConstraints() {
        view.addSubview(followingLabelButtonStackView)
        followingLabelButtonStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(27)
            $0.height.equalTo(32)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(followingLabelButtonStackView.snp.bottom).inset(-12)
            $0.height.equalTo(70)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        view.addSubview(baseLine)
        baseLine.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).inset(-12)
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(chattingListLabel)
        chattingListLabel.snp.makeConstraints {
            $0.top.equalTo(baseLine.snp.bottom).inset(-16)
            $0.leading.equalToSuperview().inset(26)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(chattingListLabel.snp.bottom).inset(-20)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ChattingHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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

extension ChattingHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleChatting.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChattingHomeTableViewCell.identifier, for: indexPath) as? ChattingHomeTableViewCell else {
            return UITableViewCell()
        }
        let chatData = sampleChatting[indexPath.row]
        let memberNickname = chatData["memberNickname"] as? String ?? ""
        let memberProfileUrl = chatData["memberProfileUrl"] as? String ?? ""
        let unReadCount = chatData["unReadCount"] as? Int ?? 0
        let lastMessage = chatData["lastMessage"] as? String ?? ""
        let lastMessageTime = chatData["lastMessageTime"] as? String ?? ""
        
        cell.configure(memberNickname: memberNickname, memberProfileUrl: memberProfileUrl, unReadCount: unReadCount, lastMessage: lastMessage, lastMessageTime: lastMessageTime)
        cell.selectionStyle = .none
        return cell
    }
    
    
}
