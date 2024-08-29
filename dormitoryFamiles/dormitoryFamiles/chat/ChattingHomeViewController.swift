import UIKit
import SnapKit

class ChattingHomeViewController: UIViewController {
    var keyword: String?
    private var followingData: [MemberProfile] = []
    private var followingPage = 0
    private var isFollowingLast = false
    
    private var chattingRoomData: [ChattingRoom] = []
    private var chattingRoomPage = 0
    private var isChattingLast = false
    
    private var isLoading = false
    var didFollowingMoreButtonTapped = false
    
    private let followingLabelButtonStackView = LabelAndRoundButtonStackView(labelText: "팔로잉", textFont: .title2 ?? UIFont(), buttonText: "전체보기", buttonHasArrow: true)
    
    private let collectionView = UserProfileNicknameCollectionView(spacing: 12, scrollDirection: .horizontal)
    
    private var isInitialLoad = true
    
    private var userNickname = ""
    private var userProfileUrl = ""
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ChattingHomeTableViewCell.self, forCellReuseIdentifier: ChattingHomeTableViewCell.identifier)
        return tableView
    }()
    
    private let baseLine: UIView = {
        let view = UIView()
        view.backgroundColor = .gray2
        view.alpha = 0.3
        return view
    }()
    
    private let chattingListLabel: UILabel = {
        let label = UILabel()
        label.font = .title2
        label.text = "채팅목록"
        return label
    }()
    
    private var profileView: ProfileView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        followingLabelButtonStackView.addButtonTarget(target: self, action: #selector(followingMoreButtonTapped), for: .touchUpInside)
        setNavigationBar()
        setCollectionView()
        setTableView()
        setConstraints()
        tableView.separatorStyle = .none
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewChatMessage(_:)), name: .newChatMessage, object: nil)
        setupTapGestureRecognizer()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .newChatMessage, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        // 잠시 지연하여 네트워크 연결 후 UI그리도록(동시성문제로 데이터 받아오는데 버그 해결을 위함)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.reloadDataAndUI()
        }
    }
    
    private func reloadDataAndUI() {
        self.followingData = []
        self.chattingRoomData = []
        self.followingPage = 0
        self.chattingRoomPage = 0
        self.isInitialLoad = true
        self.setApi(keyword: self.keyword)
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
                self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }
        }
    }
    
    @objc func followingMoreButtonTapped() {
        let searchChattingViewController = SearchChattingViewController()
        didFollowingMoreButtonTapped = true
        self.navigationController?.pushViewController(SearchChattingViewController(), animated: true)
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
        
        view.addSubview(collectionView)
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
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(chattingListLabel.snp.bottom).inset(-20)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setApi(keyword: String?) {
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
                    self.collectionView.reloadData()
                    self.isInitialLoad = false
                }
                self.isLoading = false
            case .failure(let error):
                print("Error: \(error)")
                self.isLoading = false
            }
        }
    }
    
    private func chatListApiNetwork(url: String) {
        print(chattingRoomPage)
        Network.getMethod(url: url) { (result: Result<ChattingRoomsResponse, Error>) in
            switch result {
            case .success(let response):
                self.chattingRoomData += response.data.chatRooms
                self.isChattingLast = response.data.isLast
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                self.isLoading = false
                self.chattingRoomPage += 1
            case .failure(let error):
                print("Error: \(error)")
                self.isLoading = false
            }
        }
    }
    
    private func exitChattingRoomApiNetwork(url: String) {
        Network.deleteMethod(url: url) { (result: Result<CodeResponse, Error>) in
            switch result {
            case .success(let response):
                print("Success with code: \(response.code)")
            case .failure(let error):
                print("Failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    private func chattingRoomloadNextPage() {
        guard !isChattingLast else { return }
        chatListApiNetwork(url: Url.chattingRoom(page: chattingRoomPage, size: nil, keyword: keyword))
        chattingRoomPage += 1
    }
    
    private func followingLoadNextPage() {
        guard !isFollowingLast else { return }
        followingApiNetwork(url: Url.following(page: followingPage, size: nil, keyword: keyword))
        followingPage += 1
    }
    
    private func createChattingRoom(memberId: Int) {
        Network.postMethod(url: Url.createChattingRoom(memberId: memberId), body: nil) { (result: Result<CreateRoomResponse, Error>) in
            switch result {
            case .success(let response):
                // 성공적으로 채팅방이 생성되면, 해당 채팅방으로 이동
                DispatchQueue.main.async {
                    let chattingDetailViewController = ChattingDetailViewController()
                    chattingDetailViewController.roomId = response.data.chatRoomId
                    chattingDetailViewController.nickname = self.userNickname
                    chattingDetailViewController.profileImageUrl = self.userProfileUrl
                    self.removeProfileView()
                    self.navigationController?.pushViewController(chattingDetailViewController, animated: true)
                }
            case .failure(let error):
                if let nsError = error as NSError?,
                   let statusCode = nsError.userInfo["statusCode"] as? Int {
                    switch statusCode {
                    case 404:
                        print("Error 404: \(nsError.localizedDescription)")
                    case 409:
                        print("Error 409: \(nsError.localizedDescription)")
                        // 재입장 요청
                        self.reCreateChattingRoom(memberId: memberId)
                    default:
                        print("Error \(statusCode): \(nsError.localizedDescription)")
                    }
                }
            }
        }
    }
    
    private func reCreateChattingRoom(memberId: Int) {
        Network.patchMethod(url: Url.createChattingRoom(memberId: memberId)) { (result: Result<CreateRoomResponse, Error>) in
            switch result {
            case .success(let response):
                print("재압장: \(response)")
                DispatchQueue.main.async {
                    let chattingDetailViewController = ChattingDetailViewController()
                    chattingDetailViewController.roomId = response.data.chatRoomId
                    chattingDetailViewController.nickname = self.userNickname
                    chattingDetailViewController.profileImageUrl = self.userProfileUrl
                    self.removeProfileView()
                    self.navigationController?.pushViewController(chattingDetailViewController, animated: true)
                }
            case .failure(let error):
                print("Failed with error: \(error.localizedDescription)")
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
        //터치이벤트가 계속 전달되도록 하기 위해 cancelsTouchesInView = false
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    //프로필뷰가 아닌 다른곳을 눌렀을때 프로필뷰 사라지도록 하는 메서드
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

extension ChattingHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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

extension ChattingHomeViewController: UITableViewDelegate, UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "나가기") { [self] (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
                
                let alert = UIAlertController(title: "채팅방을 나가시겠어요?", message: "대화 내용이 모두 삭제됩니다.", preferredStyle: .alert)
                       
                let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                alert.addAction(cancel)
                       
                let leave = UIAlertAction(title: "나가기", style: .destructive) { _ in
                    self.exitChattingRoomApiNetwork(url: Url.exitChattingRoom(roomId: self.chattingRoomData[indexPath.row].roomId))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.reloadDataAndUI()
                    }
                }
                alert.addAction(leave)
                self.present(alert, animated: true, completion: nil)
                
                success(true)
            }
            
            delete.backgroundColor = .primary
            return UISwipeActionsConfiguration(actions: [delete])
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

extension ChattingHomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if scrollView == tableView {
            if !isInitialLoad {
                if offsetY > contentHeight - height {
                    if !isLoading {
                        isLoading = true
                        chattingRoomloadNextPage()
                    }
                }
            }
        } else if scrollView == collectionView {
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

extension ChattingHomeViewController: ProfileViewDelegate {
    func chattingButtonTapped(memberId: Int) {
        //채팅방이 있는 경우
        if let chattingRoom = chattingRoomData.first(where: { $0.memberId == memberId }) {
            // 채팅방이 있는 경우
            let chattingDetailViewController = ChattingDetailViewController()
            chattingDetailViewController.nickname = chattingRoom.memberNickname
            chattingDetailViewController.profileImageUrl = chattingRoom.memberProfileUrl
            chattingDetailViewController.roomId = chattingRoom.roomId
            removeProfileView()
            self.navigationController?.pushViewController(chattingDetailViewController, animated: true)
        } else {
            // 채팅방이 없는 경우
            createChattingRoom(memberId: memberId)
            
        }
    }
    
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
                self.setApi(keyword: SearchChattingViewController.keyword)
            }
        }
        alert.addAction(leave)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
