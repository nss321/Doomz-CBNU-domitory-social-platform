import UIKit
import SnapKit
import Kingfisher
import StompClientLib

class ChattingDetailViewController: UIViewController, ConfigUI, StompClientLibDelegate {
    let tableView = UITableView()
    var roomId = 0
    var roomUUID = "" {
        didSet {
            soketClient.subscribe(destination: roomUUID)
        }
    }
    var messages: [ChatMessage] = []
    var isLoading = false
    var page = 0
    var isLast = false
    let url = URL(string: Url.webSocket())
    public var soketClient = StompClientLib()
    private var profileStackView: ChattingNavigationProfileStackView!
    var profileImageUrl: String?
    var nickname: String?
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
        setNavigationBar()
        setupTableView()
        registerSocket()
        initializeChatting()
        addComponents()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func createProfileStackView() -> ChattingNavigationProfileStackView {
        profileStackView = ChattingNavigationProfileStackView(frame: .zero)
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
        let tabBarHeight = tabBarController?.tabBar.frame.size.height ?? 49
        
        containerView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(tabBarHeight)
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
    
    @objc func moreButtonTapped() {
        print("moreButtonTapped")
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
                        tableView.reloadData()
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
    
    func registerSocket() {
        guard let url = URL(string: Url.webSocket()) else { return }
        let request = URLRequest(url: url)
        let token = Token.shared.number
        
        soketClient.openSocketWithURLRequest(request: request as NSURLRequest, delegate: self, connectionHeaders: ["AccessToken":"Bearer \(token)"])
    }
    
    func stompClient(client: StompClientLib, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        print("메세지 받음")
    }
    
    func stompClientDidDisconnect(client: StompClientLib!) {
        print("Socket is Disconnected")
    }
    
    func stompClientDidConnect(client: StompClientLib!) {
        print("Socket is connected")
        soketClient.subscribe(destination: roomUUID)
    }
    
    func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
        print("Receipt: \(receiptId)")
    }
    
    func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
        print("Error Send: \(description)")
        dump(description)
        if let message = message {
            print("Error Description: \(message)")
            dump(message)
        }
        reconnectSocket()
    }
    
    func reconnectSocket() {
        // Implement reconnect logic if needed
    }
    
    func serverDidSendPing() {
        print("Server ping")
    }
    
    func sendMessage(message: String) {
        let connectMessage = [
            "roomUUID": roomUUID,
            "senderId": 3,
            "message": "\(message)"
        ] as [String : Any]
        soketClient.sendJSONForDict(dict: connectMessage as NSDictionary, toDestination: "/pub/message")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let currentDateString = dateFormatter.string(from: Date())
        
        let formattedTime = DateUtility.formatTime(currentDateString)
        let newMessage = ChatMessage(memberId: 3, isSender: true, memberNickname: nickname ?? "", memberProfileUrl: profileImageUrl ?? "", chatMessage: message, sentTime: formattedTime)
        messages.append(newMessage)
        tableView.reloadData()
        scrollToBottom()
    }
    
    func sendWebSocket(dto: StompSendDTO) {
        let sendToDestination = "/pub/message"
        if soketClient.isConnected() {
            do {
                let dict = try dto.toDictionary()
                soketClient.sendJSONForDict(dict: dict as NSDictionary, toDestination: sendToDestination)
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
