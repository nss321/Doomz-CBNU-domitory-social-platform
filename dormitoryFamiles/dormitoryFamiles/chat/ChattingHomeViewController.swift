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
        followingLabelButtonStackView.addButtonTarget(target: self, action: #selector(followingMoreButtonTapped), for: .touchUpInside)
        setNavigationBar()
        setCollectionView()
        setTableView()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        followingData = []
        chattingRoomData = []
        setApi(keyword: keyword)
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
            case .failure(let error):
                print("Error: \(error)")
                self.isLoading = false
            }
        }
    }
    
    private func chattingRoomloadNextPage() {
        guard !isChattingLast else { return }
        chattingRoomPage += 1
        chatListApiNetwork(url: Url.chattingRoom(page: chattingRoomPage, size: 1, keyword: keyword))
    }
    
    private func followingLoadNextPage() {
        guard !isFollowingLast else { return }
        followingPage += 1
        followingApiNetwork(url: Url.following(page: followingPage, size: 1, keyword: keyword))
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
        let delete = UIContextualAction(style: .normal, title: "나가기") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            print("나가기\(indexPath)")
            success(true)
        }
        delete.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chattingRoom = chattingRoomData[indexPath.row]
        
        let chattingDetailViewController = ChattingDetailViewController()
        chattingDetailViewController.nickname = chattingRoom.memberNickname
        chattingDetailViewController.profileImageUrl = chattingRoom.memberProfileUrl
        self.navigationController?.pushViewController(chattingDetailViewController, animated: true)
    }
}

extension ChattingHomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if scrollView == tableView {
            if offsetY > contentHeight - height {
                if !isLoading {
                    isLoading = true
                    chattingRoomloadNextPage()
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
