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
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100 // 적당한 초기값 설정
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetData()
        loadInitialData()
    }
    
    deinit {
        //알람 뷰컨트롤러에서 다른 화면으로 전환시 안읽은 알람들이 읽음으로 바뀌는것보단
        //알람 뷰컨트롤러를 deinit하는 시점에 read처리가 더 올바르다고 판단 후 changeReadAlarm 시점 변경
        changeReadAlarm()
    }
    
    private func resetData() {
        alarmData = []
        page = 0
        isLast = false
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
    
    private func changeReadAlarm() {
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
    
    //    private func getAlarmList(url: String) {
    //        Network.getMethod(url: url) { (result: Result<NotificationsResponse, Error>) in
    //            switch result {
    //            case .success(let response):
    //                self.alarmData += response.data.notifications
    //                self.isLast = response.data.isLast
    //                self.alarmData.filter{$0.isRead == false}.forEach{
    //                    self.unreadId.append($0.notificationId)
    //                }
    //                DispatchQueue.main.sync {
    //                    self.tableView.reloadData()
    //                }
    //                self.isLoading = false
    //                self.page += 1
    //                print(response)
    //            case .failure(let error):
    //                print("Error: \(error)")
    //                self.isLoading = false
    //            }
    //        }
    //    }
    
    //아직 내 계정에 알림 목록이 없어서, 목데이터 확인용
    private func getAlarmList(url: String) {
        // 더미 데이터
        let dummyData = NotificationsResponse(
            code: 200,
            data: NotificationsDataClass(
                isLast: false,
                notifications: [
                    NotificationData(
                        notificationId: 68,
                        type: "ARTICLE_WISH",
                        sender: "바이오헬스천재",
                        articleTitle: "바퀴벌레 잡아주실 분",
                        isRead: false,
                        targetId: 58,
                        createdAt: "2024-08-20T17:04:04"
                    ),
                    NotificationData(
                        notificationId: 67,
                        type: "ARTICLE_REPLY_COMMENT",
                        sender: "바이오헬스천재",
                        articleTitle: "바퀴벌레 잡아주실 분",
                        isRead: false,
                        targetId: 58,
                        createdAt: "2024-08-20T17:01:50"
                    ),
                    NotificationData(
                        notificationId: 66,
                        type: "ARTICLE_COMMENT",
                        sender: "바이오헬스천재",
                        articleTitle: "바퀴벌레 잡아주실 분",
                        isRead: false,
                        targetId: 58,
                        createdAt: "2024-08-20T17:00:02"
                    ),
                    NotificationData(
                        notificationId: 64,
                        type: "CHAT",
                        sender: "농생명천재",
                        articleTitle: nil,
                        isRead: false,
                        targetId: 1,
                        createdAt: "2024-08-20T16:46:01"
                    )
                ]
            )
        )
        
        // 데이터 처리
        self.alarmData += dummyData.data.notifications
        self.isLast = dummyData.data.isLast
        self.alarmData.filter { $0.isRead == false }.forEach {
            self.unreadId.append($0.notificationId)
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        self.isLoading = false
        self.page += 1
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
        print("\(indexPath.row)번째 셀이 눌렸다")
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
                if !isLoading {
                    isLoading = true
                    loadNextPage()
                }
            }
        }
    }
}
