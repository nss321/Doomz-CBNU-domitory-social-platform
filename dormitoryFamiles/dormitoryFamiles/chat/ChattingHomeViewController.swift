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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        followingLabelButtonStackView.addButtonTarget(target: self, action: #selector(followingMoreButtonTapped), for: .touchUpInside)
        setNavigationBar()
        setCollectionView()
        setTableView()
        setConstraints()
        tableView.separatorStyle = .none
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewChatMessage(_:)), name: .newChatMessage, object: nil)
        createChattingRoom(memberId: 2)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .newChatMessage, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        followingData = []
        chattingRoomData = []
        followingPage = 0
        chattingRoomPage = 0
        isInitialLoad = true
        setApi(keyword: keyword)
    }

    @objc func handleNewChatMessage(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let message = notification.object as? ChatMessage else {
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
        Network.deleteMethod(url: url) { (result: Result<ExitRoomResponse, Error>) in
            switch result {
            case .success(let response):
                print("Success with code: \(response.code)")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
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
        Network.postMethod(url: Url.createChattingRoom(memberId: memberId)) { (result: Result<CreateRoom, Error>) in
            switch result {
            case .success(let response):
                print("Success with code: \(response.chatRoomId)")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                if let nsError = error as NSError?,
                   let statusCode = nsError.userInfo["statusCode"] as? Int {
                    switch statusCode {
                    case 404:
                        print("Error 404: \(nsError.localizedDescription)")
                    case 409:
                        print("Error 409: \(nsError.localizedDescription)")
                        self.reCreateChattingRoom(memberId: memberId)
                    default:
                        print("Error \(statusCode): \(nsError.localizedDescription)")
                    }
                }
            }
        }
    }
    
    private func reCreateChattingRoom(memberId: Int) {
        Network.patchMethod(url: Url.createChattingRoom(memberId: memberId)) { (result: Result<CreateRoom, Error>) in
            switch result {
            case .success(let response):
                print("재압장: \(response.chatRoomId)")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    private func setProfileView(profileView: ProfileView) {
        view.addSubview(profileView)
        profileView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(284)
           
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
        let profileView = ProfileView()
        
        profileView.setNickname(nickName: followingData[indexPath.row].nickname)
        
        setProfileView(profileView: profileView)
        
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
            
            let chattingRoomId = chattingRoomData[indexPath.row].roomId
            exitChattingRoomApiNetwork(url: Url.exitChattingRoom(roomId: chattingRoomId))
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
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
