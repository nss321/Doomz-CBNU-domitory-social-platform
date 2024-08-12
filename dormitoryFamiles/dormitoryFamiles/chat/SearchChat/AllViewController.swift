import UIKit
import SnapKit

class AllViewController: UIViewController {
    var keyword: String?
    private var followingData: [MemberProfile] = []
    private var followingPage = 0
    private var isFollowingLast = false
    
    private var chattingRoomData: [ChattingRoom] = []
    private var chattingRoomPage = 0
    private var isChattingLast = false
    
    private var isLoading = false
    var didFollowingMoreButtonTapped = false
    
    private var userNickname = ""
    private var userProfileUrl = ""
    
    private var profileView: ProfileView?
    
    private let followingLabelAndButtonStackView = LabelAndRoundButtonStackView(labelText: "팔로잉", textFont: .title2 ?? UIFont(), buttonText: "더보기", buttonHasArrow: true)
    private let chattingRoomLabelAndButtonStackView = LabelAndRoundButtonStackView(labelText: "채팅방", textFont: .title2 ?? UIFont(), buttonText: "더보기", buttonHasArrow: true)
    private let followingCollectionView = UserProfileNicknameCollectionView(spacing: 20, scrollDirection: .horizontal)
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
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewChatMessage(_:)), name: .newChatMessage, object: nil)
        setupTapGestureRecognizer()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .newChatMessage, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        followingData = []
        chattingRoomData = []
        chattingRoomPage = 0
        isChattingLast = false
        setApi(keyword: keyword)
    }
    
    private func setButtonActon() {
        followingLabelAndButtonStackView.addButtonTarget(target: self, action: #selector(followingMoreButtonTapped), for: .touchUpInside)
        chattingRoomLabelAndButtonStackView.addButtonTarget(target: self, action: #selector(chattingRoomMoreButtonTapped), for: .touchUpInside)
    }
    
    @objc func handleNewChatMessage(_ notification: Notification) {
        guard let message = notification.object as? ChatMessage else {
            return
        }
        
        if let index = self.chattingRoomData.firstIndex(where: { $0.memberId == message.memberId }) {
            self.chattingRoomData[index].lastMessage = message.chatMessage
            self.chattingRoomData[index].unReadCount += 1
            self.chattingRoomData[index].lastMessageTime = message.sentTime
            
            DispatchQueue.main.async {
                self.chattingRoomTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }
        }
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
    
    private func setApi(keyword: String?) {
        // API 호출하여 데이터 로딩
        followingApiNetwork(url: Url.following(page: followingPage, size: nil, keyword: keyword))
        chatListApiNetwork(url: Url.chattingRoom(page: chattingRoomPage, size: nil, keyword: keyword))
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
                self.chattingRoomPage += 1
            case .failure(let error):
                print("Error: \(error)")
                self.isLoading = false
            }
        }
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
    
    private func setCollectionView() {
        followingCollectionView.delegate = self
        followingCollectionView.dataSource = self
    }
    
    private func setTableView() {
        chattingRoomTableView.delegate = self
        chattingRoomTableView.dataSource = self
    }
    
    private func addComponents() {
        [followingLabelAndButtonStackView, chattingRoomLabelAndButtonStackView, followingCollectionView, chattingRoomTableView].forEach {
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
    }
}

extension AllViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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

extension AllViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chattingRoomData.count
    }
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chattingRoom = chattingRoomData[indexPath.row]
        
        let chattingDetailViewController = ChattingDetailViewController()
        chattingDetailViewController.nickname = chattingRoom.memberNickname
        chattingDetailViewController.profileImageUrl = chattingRoom.memberProfileUrl
        chattingDetailViewController.roomId = chattingRoom.roomId
        removeProfileView()
        self.navigationController?.pushViewController(chattingDetailViewController, animated: true)
    }
}

extension AllViewController: ProfileViewDelegate {
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
        print("\(memberId) 팔로잉 눌림")
    }
}
