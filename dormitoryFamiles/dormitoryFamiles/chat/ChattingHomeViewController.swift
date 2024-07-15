//
//  chattingHomeViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/07/12.
//

import UIKit
import SnapKit

class ChattingHomeViewController: UIViewController {
    let sampleNickname = ["동민","소민","유림","정훈","화진","민경","채영","보희","민주","은아"]
    
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
    private let followingLabelButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        return stackView
    }()
    
    private let followingLabel: UILabel = {
        let label = UILabel()
        label.font = .title2
        label.text = "팔로잉"
        return label
    }()
    
    private let moreFollowingbutton: PrimaryButton = {
        let button = PrimaryButton(title: "전체보기", isArrow: true)
        return button
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 48, height: 70)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ChatFollowingCollectionViewCell.self, forCellWithReuseIdentifier: ChatFollowingCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
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
        addComponents()
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
        print("돋보기 버튼 눌림")
    }
    
    @objc func logoButtonTapped() {
        print("로고 버튼 눌림")
    }
    
    private func addComponents() {
        view.addSubview(followingLabelButtonStackView)
        [followingLabel, moreFollowingbutton].forEach{
            followingLabelButtonStackView.addArrangedSubview($0) }
    }
    
    private func setConstraints() {
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
        return sampleNickname.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatFollowingCollectionViewCell.identifier, for: indexPath) as? ChatFollowingCollectionViewCell else {
            fatalError()
        }
        cell.configure(with: sampleNickname[indexPath.row])
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
