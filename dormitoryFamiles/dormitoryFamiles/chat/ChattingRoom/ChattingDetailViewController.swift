//
//  ChattingDetailViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/07/21.
//

import UIKit
import SnapKit
import Kingfisher

class ChattingDetailViewController: UIViewController, ConfigUI {
    
    let tableView = UITableView()
    
    var messages: [ChatMessage] = []
    
    private var profileStackView: ChattingNavigationProfileStackView!
    var profileImageUrl: String?
    var nickname: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setNavigationBar()
        setupTableView()
        fetchData()
        addComponents()
        setConstraints()
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
    }
    
    func setConstraints() {
        tableView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.left.trailing.equalToSuperview().inset(20)
        }
    }
    
    @objc func moreButtonTapped() {
        print("moreButtonTapped")
    }
    
    func setupTableView() {
        tableView.separatorStyle = .none
        tableView.selectionFollowsFocus = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(MyChattingTableViewCell.self, forCellReuseIdentifier: "MyChattingTableViewCell")
        tableView.register(YourChattingTableViewCell.self, forCellReuseIdentifier: "YourChattingTableViewCell")
    }
    func fetchData() {
        // API 호출을 통해 데이터를 받아온다고 가정
        let jsonResponse = """
            {
                "code": 200,
                "data": {
                    "nowPageNumber": 0,
                    "isLast": true,
                    "roomUUID": "378d1500-16e2-438d-b4e4-9c795d9ad25a",
                    "chatHistory": [
                        {
                            "memberId": 1,
                            "isSender": true,
                            "memberNickname": "닉네임11111",
                            "memberProfileUrl": "http://t1.kakaocdn.net/account_images/default_profile.jpeg.twg.thumb.R640x640",
                            "chatMessage": "진짜니ㅏ더기나ㅓㅏㄴd야ㅑㅑ이거왜짤리냐왜왜오애왜12345678901235647834239479안녕하세요? 왜 짤리나요:? 오악 업서엉진짜어이가없다구여여어어어어어엉높이를지정하지도않았는데 왜 10줄이 넘어가면 ...로 축약이 될까 왜일까 ㅠㅠ 니ㅏ러니다거니ㅏ거니ㅏ거ㅣㅏ더ㅣ라ㅓ키ㅏㅓ킨러키ㅏㄴ러키나얼키ㅏ너리ㅏ",
                            "sentTime": "2024-07-09T23:07:44"
                        },
                        {
                            "memberId": 3,
                            "isSender": false,
                            "memberNickname": "닉네임3",
                            "memberProfileUrl": "http://t1.kakaocdt/account_images/default_profile.jpeg.twg.thumb.R640x640",
                            "chatMessage": "마지막일까여ㅛ?????????????????????????두줄",
                            "sentTime": "2024-07-09T23:07:43"
                        },
                        {
                            "memberId": 3,
                            "isSender": false,
                            "memberNickname": "닉네임3",
                            "memberProfileUrl": "http://t1.kakaocdn.net/account_images/default_profile.jpeg.twg.thumb.R640x640",
                            "chatMessage": "제발",
                            "sentTime": "2024-07-09T23:07:41"
                        },
                        {
                            "memberId": 1,
                            "isSender": true,
                            "memberNickname": "닉네임11111",
                            "memberProfileUrl": "http://t1.kakaocdn.net/account_images/default_profile.jpeg.twg.thumb.R640x640",
                            "chatMessage": "이게",
                            "sentTime": "2024-07-09T23:07:40"
                        }
                    ]
                }
            }
            """
        
        if let data = jsonResponse.data(using: .utf8) {
            do {
                let response = try JSONDecoder().decode(ApiResponse.self, from: data)
                self.messages = response.data.chatHistory
                self.tableView.reloadData()
            } catch {
                print("Error decoding JSON: \(error)")
            }
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
        //셀의 높이 자동 조정
        return UITableView.automaticDimension
    }
}

