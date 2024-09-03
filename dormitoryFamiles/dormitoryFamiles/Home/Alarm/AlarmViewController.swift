//
//  AlarmViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 8/30/24.
//

import UIKit

class AlarmViewController: UIViewController, ConfigUI {
    
    private var unreadId = [Int]()
    private var alarmData = [NotificationData]()
    private var page = 0
    private var isLoading = false
    private var isLast = false
    private var chattingRoomData: [ChattingRoom] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setTableView()
        addComponents()
        setConstraints()
        self.navigationController?.isNavigationBarHidden = false
        setupNavigationBar("알림")
        getAlarmList(url: Url.alarmList(page: 0, size: nil))
        chatListApiNetwork(url: Url.chattingRoom(page: 0, size: 999, keyword: ""))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetData()
        loadInitialData()
    }
    
    deinit {
        //알람 뷰컨트롤러에서 다른 화면으로 전환시 안읽은 알람들이 읽음으로 바뀌는것보단
        //알람 뷰컨트롤러를 deinit하는 시점에 read처리가 더 올바르다고 판단 후 changeReadAlarm 시점 변경
        allChangeReadAlarm()
    }
    
    private func resetData() {
        alarmData = []
        page = 0
        isLast = false
        chattingRoomData = []
    }
    
    private func loadInitialData() {
        getAlarmList(url: Url.alarmList(page: page, size: nil))
    }
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AlarmTableViewCell.self, forCellReuseIdentifier: AlarmTableViewCell.identifier)
    }
    
    func addComponents() {
        view.addSubview(tableView)
    }
    
    func setConstraints() {
        tableView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func chatListApiNetwork(url: String) {
        Network.getMethod(url: url) { (result: Result<ChattingRoomsResponse, Error>) in
            switch result {
            case .success(let response):
                self.chattingRoomData += response.data.chatRooms
            case .failure(let error):
                print("채팅룸 데이터 받아오기 실패: \(error)")
            }
        }
    }
    
    private func allChangeReadAlarm() {
        let requestBody: [String: Any] = ["notificationIds": unreadId]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            Network.putMethod(url: Url.changeReadAlarm(), body: jsonData) { (result: Result<CodeResponse, Error>) in
                switch result {
                case .success(let successCode):
                    print("PUT 성공: \(successCode)")
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        } catch {
            print("JSON 변환 에러: \(error)")
        }
    }
    
    private func changeReadAlarm(id: Int) {
        let requestBody: [String: Any] = ["notificationIds": id]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            Network.putMethod(url: Url.changeReadAlarm(), body: jsonData) { (result: Result<CodeResponse, Error>) in
                switch result {
                case .success(let successCode):
                    print("PUT 성공: \(successCode)")
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        } catch {
            print("JSON 변환 에러: \(error)")
        }
    }
    
    private func getAlarmList(url: String) {
        guard !isLoading else { return }
        isLoading = true
        
        Network.getMethod(url: url) { (result: Result<NotificationsResponse, Error>) in
            switch result {
            case .success(let response):
                self.alarmData += response.data.notifications
                self.isLast = response.data.isLast
                self.unreadId = []
                self.alarmData.filter{$0.isRead == false}.forEach{
                    self.unreadId.append($0.notificationId)
                }
                DispatchQueue.main.sync {
                    self.tableView.reloadData()
                }
                self.isLoading = false
                self.page += 1
                print(response)
            case .failure(let error):
                print("Error: \(error)")
                self.isLoading = false
            }
        }
    }
    
    private func createChattingRoom(memberId: Int) {
        Network.postMethod(url: Url.createChattingRoom(memberId: memberId), body: nil) { (result: Result<CreateRoomResponse, Error>) in
            switch result {
            case .success(let response):
                // 성공적으로 채팅방이 생성되면, 해당 채팅방으로 이동
                DispatchQueue.main.async {
                    let chattingDetailViewController = ChattingDetailViewController()
                    chattingDetailViewController.roomId = response.data.chatRoomId
                    chattingDetailViewController.nickname = ""
                    chattingDetailViewController.profileImageUrl = ""
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
                    default:
                        print("Error \(statusCode): \(nsError.localizedDescription)")
                    }
                }
            }
        }
    }
    
    private func loadNextPage() {
        guard !isLast else { return }
        page += 1
        getAlarmList(url: Url.alarmList(page: page, size: nil))
    }
}

extension AlarmViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlarmTableViewCell.identifier, for: indexPath) as? AlarmTableViewCell else {
            return UITableViewCell()
        }
        let alarmData = alarmData[indexPath.row]
        let articleTitle = alarmData.articleTitle
        let createdAt = alarmData.createdAt
        let isRead = alarmData.isRead
        let notificationId = alarmData.notificationId
        let sender = alarmData.sender
        let targetId = alarmData.targetId
        let type = alarmData.type
        
        cell.configure(articleTitle: articleTitle, createdAt: createdAt, isRead: isRead, notificationId: notificationId, sender: sender, targetId: targetId, type: type)
        cell.selectionStyle = .none
        return cell
    }
}

extension AlarmViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alarm = alarmData[indexPath.row]

        if alarm.type.contains("ARTICLE") {
            let id = alarm.targetId
            let url = Url.searchBulletinBoard(id: id)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let articleDetailViewController = storyboard.instantiateViewController(withIdentifier: "detail") as? BulletinBoardDetailViewViewController {
                articleDetailViewController.setUrl(url: url)
                articleDetailViewController.id = id
                self.navigationController?.pushViewController(articleDetailViewController, animated: true)
            }
            changeReadAlarm(id: id)
        } else if alarm.type.contains("MEMBER") {
            //TODO: 션이 하셔야 할 로직(마이페이지 팔로워 목록 화면 전환)
        } else if alarm.type.contains("CHAT") {
            if let chattingRoom = chattingRoomData.first(where: { $0.memberId == alarm.targetId }) {
                // 채팅방이 있는 경우
                let chattingDetailViewController = ChattingDetailViewController()
                chattingDetailViewController.nickname = chattingRoom.memberNickname
                chattingDetailViewController.profileImageUrl = chattingRoom.memberProfileUrl
                chattingDetailViewController.roomId = chattingRoom.roomId
                self.navigationController?.pushViewController(chattingDetailViewController, animated: true)
            } else {
                // 채팅방이 없는 경우
                createChattingRoom(memberId: alarm.targetId)
            }
        } else if alarm.type.contains("MATCHING") {
            //TODO: 션이 하셔야 할 로직(룸메매칭 해당 화면 전환)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension AlarmViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if scrollView == tableView {
            if offsetY > contentHeight - height {
                if !isLoading && !isLast {
                    isLoading = true
                    loadNextPage()
                }
            }
        }
    }
}
