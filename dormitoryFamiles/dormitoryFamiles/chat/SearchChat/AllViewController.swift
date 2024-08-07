//
//  AllChattingViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/07/13.
//

import UIKit

class AllViewController: UIViewController {
    private var followingData: [MemberProfile] = []
    private var followingPage = 0
    private var isFollowingLast = false
    
    private var chattingRoomData: [ChattingRoom] = []
    private var chattingRoomPage = 0
    private var isChattingLast = false
    
    private var messageData: [Message] = []
    private var messagePage = 0
    private var isMessageLast = false
    
    private var isLoading = false
    
    private let followingLabelAndButtonStackView = LabelAndRoundButtonStackView(labelText: "팔로잉", textFont: .title2 ?? UIFont(), buttonText: "더보기", buttonHasArrow: true)
    
    private let chattingRoomLabelAndButtonStackView = LabelAndRoundButtonStackView(labelText: "채팅방", textFont: .title2 ?? UIFont(), buttonText: "더보기", buttonHasArrow: true)
    
    private let messageLabelAndButtonStackView = LabelAndRoundButtonStackView(labelText: "메세지", textFont: .title2 ?? UIFont(), buttonText: "더보기", buttonHasArrow: true)
    
    private let followingCollectionView = UserProfileNicknameCollectionView(spacing: 20, scrollDirection: .horizontal)
    
    private let chattingRoomTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ChattingHomeTableViewCell.self, forCellReuseIdentifier: ChattingHomeTableViewCell.identifier)
        return tableView
    }()
    
    private let messageTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ChattingHomeTableViewCell.self, forCellReuseIdentifier: ChattingHomeTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonActon()
        setCollectionView()
        setTableView()
        addComponents()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        followingData = []
        chattingRoomData = []
        messageData = []
        setApi(keyword: SearchChattingViewController.keyword)
    }
    
    private func setButtonActon() {
        followingLabelAndButtonStackView.addButtonTarget(target: self, action: #selector(followingMoreButtonTapped), for: .touchUpInside)
                chattingRoomLabelAndButtonStackView.addButtonTarget(target: self, action: #selector(chattingRoomMoreButtonTapped), for: .touchUpInside)
                messageLabelAndButtonStackView.addButtonTarget(target: self, action: #selector(messageMoreButtonTapped), for: .touchUpInside)
    }
    
       @objc private func followingMoreButtonTapped() {
           if let parentVC = self.parent?.parent as? SearchChattingViewController {
                       parentVC.scrollToPage(.at(index: 1), animated: true)
            }
       }
       
       @objc private func chattingRoomMoreButtonTapped() {
           if let parentVC = self.parent?.parent as? SearchChattingViewController {
                       parentVC.scrollToPage(.at(index: 2), animated: true)
            }
       }
       
       @objc private func messageMoreButtonTapped() {
           if let parentVC = self.parent?.parent as? SearchChattingViewController {
                       parentVC.scrollToPage(.at(index: 3), animated: true)
            }
       }
       
    
    private func setCollectionView() {
        followingCollectionView.delegate = self
        followingCollectionView.dataSource = self
    }
    
    private func setTableView() {
        chattingRoomTableView.delegate = self
        chattingRoomTableView.dataSource = self
        chattingRoomTableView.isScrollEnabled = false
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTableView.isScrollEnabled = false
    }
    
    private func setApi(keyword: String?) {
        followingApiNetwork(url: Url.following(page: followingPage, size: 5, keyword: keyword))
        chatListApiNetwork(url: Url.chattingRoom(page: chattingRoomPage, size: 2, keyword: keyword))
        messageListApiNetwork(url: Url.message(page: messagePage, size: nil, keyword: keyword, sorted: "latest"))
    }
    
    private func addComponents() {
        [followingLabelAndButtonStackView, chattingRoomLabelAndButtonStackView, messageLabelAndButtonStackView, followingCollectionView, chattingRoomTableView, messageTableView].forEach {
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
        
        chattingRoomLabelAndButtonStackView.snp.makeConstraints {
            $0.top.equalTo(followingCollectionView.snp.bottom).inset(-32)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(32)
        }
        
        chattingRoomTableView.snp.makeConstraints {
            $0.top.equalTo(chattingRoomLabelAndButtonStackView.snp.bottom).inset(-12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(146)
        }
        
        messageLabelAndButtonStackView.snp.makeConstraints {
            $0.top.equalTo(chattingRoomTableView.snp.bottom).inset(-32)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(32)
        }
        
        messageTableView.snp.makeConstraints {
            $0.top.equalTo(messageLabelAndButtonStackView.snp.bottom).inset(-12)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func followingApiNetwork(url: String) {
        if url.contains("search") {
            Network.getMethod(url: url) { (result: Result<FollowingUserSearchResponse, Error>) in
                switch result {
                case .success(let response):
                    self.followingData += response.data.memberProfiles
                    DispatchQueue.main.async {
                        self.followingCollectionView.reloadData()
                    }
                    self.isLoading = false
                case .failure(let error):
                    print("Error: \(error)")
                    self.isLoading = false
                }
            }
        }else {
            Network.getMethod(url: url) { (result: Result<FollowingUserResponse, Error>) in
                switch result {
                case .success(let response):
                    self.followingData += response.data.memberProfiles
                    self.isFollowingLast = response.data.isLast
                    DispatchQueue.main.async {
                        self.followingCollectionView.reloadData()
                    }
                    self.isLoading = false
                case .failure(let error):
                    print("Error: \(error)")
                    self.isLoading = false
                }
            }
        }
    }
    
    private func chatListApiNetwork(url: String) {
        Network.getMethod(url: url) { (result: Result<ChattingRoomsResponse, Error>) in
            switch result {
            case .success(let response):
                self.chattingRoomData += response.data.chatRooms
                self.isChattingLast = response.data.isLast
                DispatchQueue.main.async {
                    self.chattingRoomTableView.reloadData()
                }
                self.isLoading = false
            case .failure(let error):
                print("Error: \(error)")
                self.isLoading = false
            }
        }
    }
    
    private func messageListApiNetwork(url: String) {
        Network.getMethod(url: url) { (result: Result<MessageResponse, Error>) in
            switch result {
            case .success(let response):
                self.messageData += response.data.chatHistory
                self.isMessageLast = response.data.isLast
                DispatchQueue.main.async {
                    self.messageTableView.reloadData()
                }
                self.isLoading = false
            case .failure(let error):
                print("Error: \(error)")
                self.isLoading = false
            }
        }
    }
    
    private func chattingRoomloadNextPage() {
        guard !isChattingLast else { return }
        chattingRoomPage += 1
        chatListApiNetwork(url: Url.chattingRoom(page: chattingRoomPage, size: 1, keyword: SearchChattingViewController.keyword))
    }
    
    private func followingLoadNextPage() {
        guard !isFollowingLast else { return }
        followingPage += 1
        followingApiNetwork(url: Url.following(page: followingPage, size: 1, keyword: SearchChattingViewController.keyword))
    }
    
}

extension AllViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case followingCollectionView:
            return followingData.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProfileNicknameCollectionViewControllerCell.identifier, for: indexPath) as? UserProfileNicknameCollectionViewControllerCell else {
            fatalError()
        }
       
        switch collectionView {
        case followingCollectionView:
            let profile = followingData[indexPath.row]
            cell.configure(text: profile.nickname, profileUrl: profile.profileUrl)
        default:
            break
        }
       
        return cell
    }
}

extension AllViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case chattingRoomTableView:
            return chattingRoomData.count
        case messageTableView:
            return messageData.count
        default:
            return 0
        }
    }
    
    //데이터 두개만 받아오기
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChattingHomeTableViewCell.identifier, for: indexPath) as? ChattingHomeTableViewCell else {
            return UITableViewCell()
        }
        
        switch tableView {
        case chattingRoomTableView:
            let chattingRoom = chattingRoomData[indexPath.row]
            let memberNickname = chattingRoom.memberNickname
            let memberProfileUrl = chattingRoom.memberProfileUrl ?? ""
            let unReadCount = chattingRoom.unReadCount
            let lastMessage = chattingRoom.lastMessage
            let lastMessageTime = chattingRoom.lastMessageTime
            cell.configure(memberNickname: memberNickname, memberProfileUrl: memberProfileUrl, unReadCount: unReadCount, lastMessage: lastMessage, lastMessageTime: lastMessageTime)
            
        case messageTableView:
            let message = messageData[indexPath.row]
            let memberNickname = message.memberNickname
            let memberProfileUrl = message.memberProfileUrl ?? ""
            let unReadCount = 0
            let lastMessage = message.chatMessage
            let lastMessageTime = message.sentTime
            cell.configure(memberNickname: memberNickname, memberProfileUrl: memberProfileUrl, unReadCount: unReadCount, lastMessage: lastMessage, lastMessageTime: lastMessageTime)
            cell.highlightKeyword(keyword: SearchChattingViewController.keyword ?? "")
        default:
            break
        }
        cell.selectionStyle = .none
        return cell
    }
    
}
