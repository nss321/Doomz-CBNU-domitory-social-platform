//
//  ChattingRoomViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/07/15.
//

import UIKit

class ChattingRoomViewController: UIViewController {
    
    let chattingRoomData = [
        "code": 200,
        "data": [
            "nowPageNumber": 0,
            "isLast": true,
            "chatRooms": [
                [
                    "roomId": 8,
                    "memberId": 8,
                    "memberNickname": "닉네임8",
                    "unReadCount": 0,
                    "lastMessage": "Hello, how are you?",
                    "lastMessageTime": "2024-05-30T13:58:10"
                ],
                [
                    "roomId": 7,
                    "memberId": 7,
                    "memberNickname": "닉네임7",
                    "memberProfileUrl": "http://t1.kakaocdn.net/account_images/default_profile.jpeg.twg.thumb.R640x640",
                    "unReadCount": 0,
                    "lastMessage": "Hello, how are you?",
                    "lastMessageTime": "2024-05-30T13:57:47"
                ],
                [
                    "roomId": 5,
                    "memberId": 5,
                    "memberNickname": "닉네임5",
                    "memberProfileUrl": "http://t1.kakaocdn.net/account_images/default_profile.jpeg.twg.thumb.R640x640",
                    "unReadCount": 0,
                    "lastMessage": "Hello, how are you?",
                    "lastMessageTime": "2024-05-30T13:57:10"
                ],
                [
                    "roomId": 4,
                    "memberId": 4,
                    "memberNickname": "닉네임4",
                    "memberProfileUrl": "http://t1.kakaocdn.net/account_images/default_profile.jpeg.twg.thumb.R640x640",
                    "unReadCount": 0,
                    "lastMessage": "Hello, how are you?",
                    "lastMessageTime": "2024-05-30T13:56:49"
                ],
                [
                    "roomId": 3,
                    "memberId": 3,
                    "memberNickname": "닉네임3",
                    "memberProfileUrl": "http://t1.kakaocdn.net/account_images/default_profile.jpeg.twg.thumb.R640x640",
                    "unReadCount": 0,
                    "lastMessage": "Hello, how are you?",
                    "lastMessageTime": "2024-05-30T13:56:25"
                ]
            ]
        ]
    ] as [String : Any]
    
    let chattingRoomLabel: UILabel = {
        let label = UILabel()
        label.font = .title2
        label.text = "채팅방"
        return label
    }()
    
    let chattingRoomTabelView: UITableView = {
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
    
    private func setTableView() {
        chattingRoomTabelView.delegate = self
        chattingRoomTabelView.dataSource = self
    }
    
    private func addComponents() {
        [chattingRoomLabel, chattingRoomTabelView].forEach {
            view.addSubview($0)
        }
    }
    
    private func setConstraints() {
        chattingRoomLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(66)
            $0.leading.equalToSuperview().inset(25)
            $0.height.equalTo(32)
        }
        
        chattingRoomTabelView.snp.makeConstraints{
            $0.top.equalTo(chattingRoomLabel.snp.bottom).inset(-12)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(-20)
        }
    }
}

extension ChattingRoomViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data = chattingRoomData["data"] as! [String: Any]
        let chatRoom = data["chatRooms"] as! [[String: Any]]
        return chatRoom.count
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChattingHomeTableViewCell.identifier, for: indexPath) as? ChattingHomeTableViewCell else {
            return UITableViewCell()
        }
        
        if let data = chattingRoomData["data"] as? [String: Any],
           let chatRooms = data["chatRooms"] as? [[String: Any]] {
            let chatData = chatRooms[indexPath.row]
            let memberNickname = chatData["memberNickname"] as? String ?? ""
            let memberProfileUrl = chatData["memberProfileUrl"] as? String ?? ""
            let unReadCount = chatData["unReadCount"] as? Int ?? 0
            let lastMessage = chatData["lastMessage"] as? String ?? ""
            let lastMessageTime = chatData["lastMessageTime"] as? String ?? ""
            
            cell.configure(memberNickname: memberNickname, memberProfileUrl: memberProfileUrl, unReadCount: unReadCount, lastMessage: lastMessage, lastMessageTime: lastMessageTime)
        }
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

