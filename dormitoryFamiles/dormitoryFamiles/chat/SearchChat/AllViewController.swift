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
    
    private var allDoomzData: [MemberProfile] = []
    private var allDoomzPage = 0
    private var isAllDoomzLast = false
    
    private var isLoading = false
    
    
    private let followingLabelAndButtonStackView = LabelAndRoundButtonStackView(labelText: "팔로잉", textFont: .title2 ?? UIFont(), buttonText: "더보기", buttonHasArrow: true)
    
    private let allDoomzLabelAndButtonStackView = LabelAndRoundButtonStackView(labelText: "전체둠즈", textFont: .title2 ?? UIFont(), buttonText: "더보기", buttonHasArrow: true)
    
    private let chattingRoomLabelAndButtonStackView = LabelAndRoundButtonStackView(labelText: "채팅방", textFont: .title2 ?? UIFont(), buttonText: "더보기", buttonHasArrow: true)
    
    private let messageLabelAndButtonStackView = LabelAndRoundButtonStackView(labelText: "메세지", textFont: .title2 ?? UIFont(), buttonText: "더보기", buttonHasArrow: true)
    
    private let followingCollectionView = UserProfileNicknameCollectionView(spacing: 20, scrollDirection: .horizontal)
    
    private let allDoomzCollectionView = UserProfileNicknameCollectionView(spacing: 20, scrollDirection: .horizontal)
    
    private let chattingRoomTableView: UITableView = {
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
        setApi()
    }
    
    private func setButtonActon() {
        followingLabelAndButtonStackView.addButtonTarget(target: self, action: #selector(followingMoreButtonTapped), for: .touchUpInside)
                allDoomzLabelAndButtonStackView.addButtonTarget(target: self, action: #selector(allDoomzMoreButtonTapped), for: .touchUpInside)
                chattingRoomLabelAndButtonStackView.addButtonTarget(target: self, action: #selector(chattingRoomMoreButtonTapped), for: .touchUpInside)
                messageLabelAndButtonStackView.addButtonTarget(target: self, action: #selector(messageMoreButtonTapped), for: .touchUpInside)
    }
    
       @objc private func followingMoreButtonTapped() {
           if let parentVC = self.parent?.parent as? SearchChattingViewController {
                       parentVC.scrollToPage(.at(index: 1), animated: true)
            }
       }
       
       @objc private func allDoomzMoreButtonTapped() {
           if let parentVC = self.parent?.parent as? SearchChattingViewController {
                       parentVC.scrollToPage(.at(index: 2), animated: true)
            }
       }
       
       @objc private func chattingRoomMoreButtonTapped() {
           if let parentVC = self.parent?.parent as? SearchChattingViewController {
                       parentVC.scrollToPage(.at(index: 3), animated: true)
            }
       }
       
       @objc private func messageMoreButtonTapped() {
           if let parentVC = self.parent?.parent as? SearchChattingViewController {
                       parentVC.scrollToPage(.at(index: 4), animated: true)
            }
       }
       
    
    private func setCollectionView() {
        followingCollectionView.delegate = self
        followingCollectionView.dataSource = self
        
        allDoomzCollectionView.delegate = self
        allDoomzCollectionView.dataSource = self
    }
    
    private func setTableView() {
        chattingRoomTableView.delegate = self
        chattingRoomTableView.dataSource = self
    }
    
    private func setApi() {
        followingApiNetwork(url: Url.following(page: followingPage, size: nil))
        chatListApiNetwork(url: Url.chattingRoom(page: chattingRoomPage, size: nil))
        allDoomzApiNetwork(url: Url.allDoomz(page: allDoomzPage, size: nil))
    }
    
    private func addComponents() {
        [followingLabelAndButtonStackView, allDoomzLabelAndButtonStackView, chattingRoomLabelAndButtonStackView, messageLabelAndButtonStackView, followingCollectionView, allDoomzCollectionView, chattingRoomTableView].forEach {
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
        
        chattingRoomTableView.snp.makeConstraints {
            $0.top.equalTo(chattingRoomLabelAndButtonStackView.snp.bottom).inset(-12)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func followingApiNetwork(url: String) {
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
    
    private func allDoomzApiNetwork(url: String) {
        Network.getMethod(url: url) { (result: Result<AllDoomzResponse, Error>) in
            switch result {
            case .success(let response):
                self.allDoomzData += response.data.memberProfiles
                //self.isAllDoomzLast = response.data.isLast
                DispatchQueue.main.async {
                    self.allDoomzCollectionView.reloadData()
                }
                self.isLoading = false
            case .failure(let error):
                print("Error: \(error)")
                self.isLoading = false
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
    
    private func chattingRoomloadNextPage() {
        guard !isChattingLast else { return }
        chattingRoomPage += 1
        chatListApiNetwork(url: Url.chattingRoom(page: chattingRoomPage, size: 1))
    }
    
    private func followingLoadNextPage() {
        guard !isFollowingLast else { return }
        followingPage += 1
        followingApiNetwork(url: Url.following(page: followingPage, size: 1))
    }
    
}

extension AllViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case followingCollectionView:
            return followingData.count
        case allDoomzCollectionView:
            return allDoomzData.count
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
        case allDoomzCollectionView:
            let profile = allDoomzData[indexPath.row]
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
        default:
            return 0
        }
    }
    
    //데이터 두개만 받아오기
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChattingHomeTableViewCell.identifier, for: indexPath) as? ChattingHomeTableViewCell else {
            return UITableViewCell()
        }
        
        let chattingRoom = chattingRoomData[indexPath.row]
        let memberNickname = chattingRoom.memberNickname
        let memberProfileUrl = chattingRoom.memberProfileUrl ?? ""
        let unReadCount = chattingRoom.unReadCount
        let lastMessage = chattingRoom.lastMessage
        let lastMessageTime = chattingRoom.lastMessageTime
        
        cell.configure(memberNickname: memberNickname, memberProfileUrl: memberProfileUrl, unReadCount: unReadCount, lastMessage: lastMessage, lastMessageTime: lastMessageTime)
        cell.selectionStyle = .none
        return cell
    }
    
}

extension AllViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if scrollView == chattingRoomTableView {
            if offsetY > contentHeight - height {
                if !isLoading {
                    isLoading = true
                    chattingRoomloadNextPage()
                }
            }
        } else if scrollView == followingCollectionView {
            let horizontalOffset = scrollView.contentOffset.x
            let contentWidth = scrollView.contentSize.width
            let width = scrollView.frame.size.width
            
            if horizontalOffset > contentWidth - width {
                if !isLoading {
                    isLoading = true
                    followingLoadNextPage()
                }
            }
        } else if scrollView == allDoomzCollectionView {
            let horizontalOffset = scrollView.contentOffset.x
            let contentWidth = scrollView.contentSize.width
            let width = scrollView.frame.size.width
            
            if horizontalOffset > contentWidth - width {
                if !isLoading {
                    isLoading = true
                    followingLoadNextPage()
                }
            }
        }
    }
}

