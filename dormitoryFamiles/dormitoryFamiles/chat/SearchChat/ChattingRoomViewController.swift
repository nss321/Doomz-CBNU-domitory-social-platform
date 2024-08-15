//
//  ChattingRoomViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/07/15.
//

import UIKit

class ChattingRoomViewController: UIViewController {
    private var chattingRoomData: [ChattingRoom] = []
    private var chattingRoomPage = 0
    private var isChattingLast = false
    private var isLoading = false
    
    let chattingRoomLabel: UILabel = {
        let label = UILabel()
        label.font = .title2
        label.text = "채팅방"
        return label
    }()
    
    let chattingRoomTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ChattingHomeTableViewCell.self, forCellReuseIdentifier: ChattingHomeTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        addComponents()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        chattingRoomData = []
        chattingRoomPage = 0
        chatListApiNetwork(url: Url.chattingRoom(page: chattingRoomPage, size: nil, keyword: SearchChattingViewController.keyword))
    }
    
    private func setTableView() {
        chattingRoomTableView.delegate = self
        chattingRoomTableView.dataSource = self
    }
    
    private func addComponents() {
        [chattingRoomLabel, chattingRoomTableView].forEach {
            view.addSubview($0)
        }
    }
    
    private func setConstraints() {
        chattingRoomLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(66)
            $0.leading.equalToSuperview().inset(25)
            $0.height.equalTo(32)
        }
        
        chattingRoomTableView.snp.makeConstraints{
            $0.top.equalTo(chattingRoomLabel.snp.bottom).inset(-12)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(-20)
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
    
    private func chattingRoomLoadNextPage() {
        guard !isChattingLast else { return }
        chattingRoomPage += 1
        chatListApiNetwork(url: Url.chattingRoom(page: chattingRoomPage, size: nil, keyword: SearchChattingViewController.keyword))
    }
}

extension ChattingRoomViewController: UITableViewDataSource, UITableViewDelegate {
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
        if chattingRoom.unReadCount == 0 {
            chattingDetailViewController.hasUnRead = false
        }else {
            chattingDetailViewController.hasUnRead = true
        }

        self.navigationController?.pushViewController(chattingDetailViewController, animated: true)
    }
}

extension ChattingRoomViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if scrollView == chattingRoomTableView {
            if offsetY > contentHeight - height {
                if !isLoading {
                    isLoading = true
                    chattingRoomLoadNextPage()
                }
            }
        }
    }
}
