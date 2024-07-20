//
//  MessagegViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/07/15.
//

import UIKit
import DropDown

class MessagegViewController: UIViewController {
    private var messageData: [Message] = []
    private var messagePage = 0
    private var isMessageLast = false
    private var isLoading = false
    var sorted = "latest" {
        didSet {
            messageData = []
            messagePage = 0
        }
    }
    let dropDown = DropDown()
    let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .title2
        label.text = "메세지"
        return label
    }()
    
    let sortedButton = DropdownButton(frame: CGRect(), title: "최신순")
    
    let messageTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ChattingHomeTableViewCell.self, forCellReuseIdentifier: ChattingHomeTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSortedButton()
        setTableView()
        addComponents()
        setConstraints()
        setDropDown()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        messageData = []
        messagePage = 0
        chatListApiNetwork(url: Url.message(page: messagePage, size: nil, keyword: SearchChattingViewController.keyword, sorted: sorted))
    }
    
    private func setSortedButton() {
        sortedButton.addTarget(self, action: #selector(sortedButtonTapped), for: .touchUpInside)
    }
    
    private func setTableView() {
        messageTableView.delegate = self
        messageTableView.dataSource = self
    }
    
    private func addComponents() {
        [messageLabel, sortedButton, messageTableView].forEach {
            view.addSubview($0)
        }
    }
    
    private func setConstraints() {
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(66)
            $0.leading.equalToSuperview().inset(25)
            $0.height.equalTo(32)
        }
        
        sortedButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(66)
            $0.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(32)
        }
        
        messageTableView.snp.makeConstraints{
            $0.top.equalTo(messageLabel.snp.bottom).inset(-12)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(-20)
        }
    }
    
    private func chatListApiNetwork(url: String) {
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
    
    private func messageLoadNextPage() {
        guard !isMessageLast else { return }
        messagePage += 1
        chatListApiNetwork(url: Url.message(page: messagePage, size: nil, keyword: SearchChattingViewController.keyword, sorted: sorted))
    }
    
    private func setDropDown() {
        DropDown.startListeningToKeyboard()
        DropDown.appearance().setupCornerRadius(20)
        DropDown.appearance().backgroundColor = .white
        DropDown.appearance().cellHeight = 52
        DropDown.appearance().shadowOpacity = 0
        DropDown.appearance().selectionBackgroundColor = .gray0 ?? .white
        DropDown.appearance().textFont = .pretendard14Variable ?? .init()
        DropDown.appearance().textColor = .gray4 ?? .gray
    }
    
    @objc func sortedButtonTapped() {
            dropDown.dataSource = ["최신순", "오래된순"]

        //공통으로 dropdown을 보여주기 위한 코드
        dropDown.anchorView = sortedButton
        dropDown.bottomOffset = CGPoint(x: 0, y:((dropDown.anchorView?.plainView.bounds.height)!+5))
        dropDown.show()
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            //item 선택시 -> 1. 버튼의 title변경, 2. 해당 url세팅
            self.sortedButton.body2 = item
            if item == "최신순" {
                self.sorted = "latest"
            }else {
                self.sorted = "oldest"
            }
            self.chatListApiNetwork(url: Url.message(page: self.messagePage, size: nil, keyword: SearchChattingViewController.keyword, sorted: self.sorted))
        }
    }
}

extension MessagegViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChattingHomeTableViewCell.identifier, for: indexPath) as? ChattingHomeTableViewCell else {
            return UITableViewCell()
        }
        
        let message = messageData[indexPath.row]
        let memberNickname = message.memberNickname
        let memberProfileUrl = message.memberProfileUrl ?? ""
        let unReadCount = 0
        let lastMessage = message.chatMessage
        let lastMessageTime = message.sentTime
        
        cell.configure(memberNickname: memberNickname, memberProfileUrl: memberProfileUrl, unReadCount: unReadCount, lastMessage: lastMessage, lastMessageTime: lastMessageTime)
        cell.highlightKeyword(keyword: SearchChattingViewController.keyword ?? "")
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "나가기") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            print("나가기\(indexPath)")
            success(true)
        }
        delete.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions:[delete])
    }
}

extension MessagegViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if scrollView == messageTableView {
            if offsetY > contentHeight - height {
                if !isLoading {
                    isLoading = true
                    messageLoadNextPage()
                }
            }
        }
    }
}
