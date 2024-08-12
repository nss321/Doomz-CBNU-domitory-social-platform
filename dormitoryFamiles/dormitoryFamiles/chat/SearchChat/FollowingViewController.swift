//
//  FollowingViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/07/15.
//

import UIKit

class FollowingViewController: UIViewController {
    private var followingData: [MemberProfile] = []
    private var followingPage = 0
    private var isFollowingLast = false
    private var isLoading = false
    
    private var profileView: ProfileView?
    private var userNickname = ""
    private var userProfileUrl = ""
    
    // Chatting 관련 데이터 추가한 이유: 해당 멤버와 함꼐 한 채팅방이 있는지 확인/ 있다면 그쪽의 데이터를 넘겨받아야 하기 때문
    private var chattingRoomData: [ChattingRoom] = []
    private var chattingRoomPage = 0
    private var isChattingLast = false
    
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
        setupTapGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        resetData()
        loadInitialData()
    }
    
    private func resetData() {
        followingData = []
        followingPage = 0
        isFollowingLast = false
    }
    
    private func loadInitialData() {
        followingApiNetwork(url: Url.following(page: followingPage, size: nil, keyword: SearchChattingViewController.keyword))
        chatListApiNetwork(url: Url.chattingRoom(page: 0, size: 999, keyword: SearchChattingViewController.keyword))
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
    
    private func followingApiNetwork(url: String) {
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
    }
    
    private func chatListApiNetwork(url: String) {
        Network.getMethod(url: url) { (result: Result<ChattingRoomsResponse, Error>) in
            switch result {
            case .success(let response):
                self.chattingRoomData += response.data.chatRooms
                self.isChattingLast = response.data.isLast
            case .failure(let error):
                print("Error: \(error)")
                self.isLoading = false
            }
        }
    }
    
    private func followingLoadNextPage() {
        guard !isFollowingLast else { return }
        followingPage += 1
        followingApiNetwork(url: Url.following(page: followingPage, size: nil, keyword: SearchChattingViewController.keyword))
    }
    
    private func getMemberProfile(url: String) {
        Network.getMethod(url: url) { (result: Result<ProfileResponse, Error>) in
            switch result {
            case .success(let response):
                let data = response.data
                let imageUrlString = data.profileUrl
                if let imageUrl = URL(string: imageUrlString) {
                    DispatchQueue.main.async {
                        let profileView = ProfileView()
                        profileView.setData(
                            memberId: data.memberId, nickName: data.nickname,
                            profileImageUrl: imageUrl,
                            dormitory: data.dormitoryType,
                            isFollowing: data.isFollowing
                        )
                        self.setProfileView(profileView: profileView)
                    }
                }
            case .failure(let error):
                print("Failed to fetch profile: \(error)")
            }
        }
    }
    
    private func setProfileView(profileView: ProfileView) {
        if let currentProfileView = self.profileView {
            currentProfileView.removeFromSuperview()
        }
        self.profileView = profileView
        view.addSubview(profileView)
        profileView.delegate = self
        profileView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(284)
        }
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func setupTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOutsideProfileView(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func handleTapOutsideProfileView(_ sender: UITapGestureRecognizer) {
        if let profileView = profileView {
            let touchPoint = sender.location(in: view)
            if !profileView.frame.contains(touchPoint) {
                removeProfileView()
            }
        }
    }
    
    private func removeProfileView() {
        profileView?.removeFromSuperview()
        self.profileView = nil
        self.userNickname = ""
        self.userProfileUrl = ""
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func createChattingRoom(memberId: Int) {
        Network.postMethod(url: Url.createChattingRoom(memberId: memberId)) { (result: Result<CreateRoomResponse, Error>) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    let chattingDetailViewController = ChattingDetailViewController()
                    chattingDetailViewController.roomId = response.data.chatRoomId
                    chattingDetailViewController.nickname = self.userNickname
                    chattingDetailViewController.profileImageUrl = self.userProfileUrl
                    self.removeProfileView()
                    self.navigationController?.pushViewController(chattingDetailViewController, animated: true)
                }
            case .failure(let error):
                print("Failed to create chatting room: \(error.localizedDescription)")
            }
        }
    }
    
    private func deleteFollowing(url: String) {
        Network.deleteMethod(url: url) { (result: Result<CodeResponse, Error>) in
            switch result {
            case .success(let response):
                print("Success with code: \(response.code)")
            case .failure(let error):
                print("Failed with error: \(error.localizedDescription)")
            }
        }
    }
}

extension FollowingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return followingData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProfileNicknameCollectionViewControllerCell.identifier, for: indexPath) as? UserProfileNicknameCollectionViewControllerCell else {
            fatalError()
        }
        
        let profile = followingData[indexPath.row]
        cell.configure(text: profile.nickname, profileUrl: profile.profileUrl)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let member = followingData[indexPath.row]
        self.userNickname = member.nickname
        self.userProfileUrl = member.profileUrl
        getMemberProfile(url: Url.userProfile(memberId: member.memberId))
    }
}

extension FollowingViewController: ProfileViewDelegate {
    func chattingButtonTapped(memberId: Int) {
        if let chattingRoom = chattingRoomData.first(where: { $0.memberId == memberId }) {
            let chattingDetailViewController = ChattingDetailViewController()
            chattingDetailViewController.nickname = chattingRoom.memberNickname
            chattingDetailViewController.profileImageUrl = chattingRoom.memberProfileUrl
            chattingDetailViewController.roomId = chattingRoom.roomId
            removeProfileView()
            self.navigationController?.pushViewController(chattingDetailViewController, animated: true)
        } else {
            createChattingRoom(memberId: memberId)
        }
    }
    
    func followingButtonTapped(memberId: Int) {
        func followingButtonTapped(memberId: Int) {
            let alert = UIAlertController(title: "팔로잉을 삭제하시겠어요?", message: "팔로잉 목록에서 삭제됩니다.", preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "유지하기", style: .cancel, handler: nil)
            alert.addAction(cancel)
            
            let leave = UIAlertAction(title: "삭제하기", style: .destructive) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.deleteFollowing(url: Url.deleteFollowing(memberId: memberId))
                    self.followingData = []
                    self.chattingRoomData = []
                    self.followingPage = 0
                    self.chattingRoomPage = 0
                    self.removeProfileView()
                    self.followingApiNetwork(url: SearchChattingViewController.keyword ?? "")
                }
            }
            alert.addAction(leave)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
