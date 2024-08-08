// ChattingDetailViewController.swift
import UIKit
import SnapKit
import Kingfisher
import StompClientLib

class ChattingDetailViewController: UIViewController, ConfigUI {
    let tableView = UITableView()
    var roomId = 0
    var roomUUID = "" {
        didSet {
            WebSocketManager.shared.subscribe(to: roomUUID)
        }
    }
    var messages: [ChatMessage] = []
    var isLoading = false
    var page = 0
    var isLast = false
    var profileStackView: ChattingNavigationProfileStackView!
    var profileImageUrl: String?
    var nickname: String?
    private var tapGesture: UITapGestureRecognizer?
    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "메세지 보내기"
        textField.font = .body2
        return textField
    }()
    
    private let containerView: RoundLabel = {
        let containerView = RoundLabel()
        containerView.backgroundColor = .gray0
        containerView.isUserInteractionEnabled = true
        return containerView
    }()
    
    private let sendButton: TagButton = {
        let button = TagButton()
        button.setTitle("전송", for: .normal)
        button.titleLabel?.font = .button
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .primary
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setTextField()
        setNavigationBar()
        setupTableView()
        initializeChatting()
        addComponents()
        setConstraints()
        setNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        exitChattingRoomApiNetwork(url: Url.exitChattingRoom(roomId: roomId))
        self.tabBarController?.tabBar.isHidden = false
        //채팅 내역이 없는 채팅방이라면 delete처리
        if messages.isEmpty {
            noChattingExitChattingRoomApiNetwork(url: Url.noMessageExitChattingRoom(roomId: roomId))
        }
        removeNotification()
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewMessage(_:)), name: .newChatMessage, object: nil)
    }
    
    private func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: .newChatMessage, object: nil)
    }
    
    private func setTextField() {
        self.textField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func createProfileStackView() -> ChattingNavigationProfileStackView {
        profileStackView = ChattingNavigationProfileStackView(frame: .zero)
        profileStackView.profileImageView.removeFromSuperview()
        if let url = profileImageUrl, let nickname = nickname {
            let profileImageView = Network.loadImage(url: url)
            self.profileStackView.profileImageView.image = profileImageView.image
            self.profileStackView.configure(nickname: nickname)
        }
        return profileStackView
    }
    
    private func setNavigationBar() {
        let profileStackView = createProfileStackView()
        self.navigationItem.titleView = profileStackView
    
        let moreImage = UIImage(named: "chattingDetailMore")?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: moreImage, style: .plain, target: self, action: #selector(moreButtonTapped))
    }
    
    func addComponents() {
        view.addSubview(tableView)
        view.addSubview(containerView)
        containerView.addSubview(textField)
        containerView.addSubview(sendButton)
    }
    
    func setConstraints() {
        containerView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(52)
            $0.left.trailing.equalToSuperview().inset(20)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(containerView.snp.top)
            $0.left.trailing.equalToSuperview().inset(20)
        }
        
        sendButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(56)
            $0.top.bottom.equalToSuperview().inset(8)
        }
        
        textField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalTo(sendButton.snp.leading).inset(-16)
        }
    }
    
    private func exitChattingRoomApiNetwork(url: String) {
        Network.patchMethod(url: url) { (result: Result<ExitRoomResponse, Error>) in
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
    
    @objc func moreButtonTapped() {
        let sheet = UIAlertController(title: nil, message: "채팅방 설정", preferredStyle: .actionSheet)
               
        let leaveAction = UIAlertAction(title: "나가기", style: .destructive) { _ in
                   
            let alert = UIAlertController(title: "채팅방을 나가시겠어요?", message: "대화 내용이 모두 삭제됩니다.", preferredStyle: .alert)
                   
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(cancel)
                   
            let leave = UIAlertAction(title: "나가기", style: .destructive) { _ in
                self.exitChattingRoomApiNetwork(url: Url.exitChattingRoom(roomId: self.roomId))
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(leave)
            self.present(alert, animated: true, completion: nil)
        }
        sheet.addAction(leaveAction)
               
        let cancel = UIAlertAction(title: "닫기", style: .cancel, handler: nil)
        sheet.addAction(cancel)
               
        present(sheet, animated: true, completion: nil)
    }
    
    func setupTableView() {
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.selectionFollowsFocus = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(MyChattingTableViewCell.self, forCellReuseIdentifier: "MyChattingTableViewCell")
        tableView.register(YourChattingTableViewCell.self, forCellReuseIdentifier: "YourChattingTableViewCell")
    }
    
    private func chattingHistoryApiNetwork(url: String, appendToTop: Bool = false) {
        Network.getMethod(url: url) { [self] (result: Result<ApiResponse, Error>) in
            switch result {
            case .success(let response):
                let newMessages = response.data.chatHistory
                self.isLast = response.data.isLast
                if roomUUID.isEmpty {
                    self.roomUUID = response.data.roomUUID
                }
                DispatchQueue.main.async { [self] in
                    let previousContentHeight = tableView.contentSize.height
                    if appendToTop {
                        self.messages.insert(contentsOf: newMessages, at: 0)
                        tableView.reloadData()
                        tableView.layoutIfNeeded()
                        let newContentHeight = tableView.contentSize.height
                        tableView.setContentOffset(CGPoint(x: 0, y: newContentHeight - previousContentHeight), animated: false)
                    } else {
                        self.messages.append(contentsOf: newMessages)
                        reloadTableView()
                        scrollToBottom()
                    }
                }
                self.isLoading = false
            case .failure(let error):
                print("Error: \(error)")
                self.isLoading = false
            }
        }
    }
    
    private func initializeChatting() {
        messages = []
        page = 0
        isLast = false
        chattingHistoryApiNetwork(url: Url.chattingHistory(page: page, size: nil, roomId: roomId))
    }
    
    @objc private func loadMoreData() {
        guard !isLast && !isLoading else { return }
        isLoading = true
        page += 1
        chattingHistoryApiNetwork(url: Url.chattingHistory(page: page, size: nil, roomId: roomId), appendToTop: true)
    }
    
    func sendMessage(message: String) {
        let connectMessage = [
            "roomUUID": roomUUID,
            "senderId": 3,
            "message": "\(message)"
        ] as [String : Any]
        WebSocketManager.shared.socketClient.sendJSONForDict(dict: connectMessage as NSDictionary, toDestination: "/pub/message")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let currentDateString = dateFormatter.string(from: Date())
        
        let formattedTime = DateUtility.formatTime(currentDateString)
        let newMessage = ChatMessage(memberId: 3, isSender: true, memberNickname: nickname ?? "", memberProfileUrl: profileImageUrl ?? "", chatMessage: message, sentTime: formattedTime)
        messages.append(newMessage)
        reloadTableView()
        scrollToBottom()
    }
    
    func sendWebSocket(dto: StompSendDTO) {
        let sendToDestination = "/pub/message"
        if WebSocketManager.shared.socketClient.isConnected() {
            do {
                let dict = try dto.toDictionary()
                WebSocketManager.shared.socketClient.sendJSONForDict(dict: dict as NSDictionary, toDestination: sendToDestination)
            } catch {
                print("Failed to convert StompSendDTO to Dictionary: \(error)")
            }
        } else {
            print("WebSocket is not connected")
        }
    }
    
    private func scrollToBottom() {
        DispatchQueue.main.async {
            let lastRow = self.messages.count - 1
            if lastRow >= 0 && lastRow < self.tableView.numberOfRows(inSection: 0) {
                let indexPath = IndexPath(row: lastRow, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    @objc private func sendButtonTapped() {
        guard let messageText = textField.text, !messageText.isEmpty else { return }
        sendMessage(message: messageText)
        textField.text = ""
    }
    
    private func backViewChattingRoomApiNetwork(url: String) {
        Network.patchMethod(url: url) { (result: Result<ExitRoomResponse, Error>) in
            switch result {
            case .success(let response):
                print("Success with code: \(response.code)")
            case .failure(let error):
                print("Failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    private func noChattingExitChattingRoomApiNetwork(url: String) {
        Network.deleteMethod(url: url) { (result: Result<ExitRoomResponse, Error>) in
            switch result {
            case .success(let response):
                print("Success with code: \(response.code)")
            case .failure(let error):
                print("Failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    @objc private func handleNewMessage(_ notification: Notification) {
        guard let message = notification.object as? ChatMessage else { return }
        messages.append(message)
        reloadTableView()
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension ChattingDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        if message.isSender {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyChattingTableViewCell", for: indexPath) as! MyChattingTableViewCell
            cell.configure(with: message)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "YourChattingTableViewCell", for: indexPath) as! YourChattingTableViewCell
            cell.configure(with: message)
            cell.profileImageView = profileStackView.profileImageView
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ChattingDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if scrollView == tableView && offsetY < -50 && !isLoading {
            loadMoreData()
        }
    }
}

extension ChattingDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if tapGesture == nil {
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tapGesture!)
        }
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            UIView.animate(withDuration: 0.3) {
                self.containerView.snp.updateConstraints { make in
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(keyboardHeight-30)
                }
                self.view.layoutIfNeeded()
            }
            scrollToBottom()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        if let tap = tapGesture {
            view.removeGestureRecognizer(tap)
            tapGesture = nil
        }
        UIView.animate(withDuration: 0.3) {
            self.containerView.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(8)
            }
            self.view.layoutIfNeeded()
        }
    }
}
