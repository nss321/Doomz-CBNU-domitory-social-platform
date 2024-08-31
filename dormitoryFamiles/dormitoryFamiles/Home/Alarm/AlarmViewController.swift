//
//  AlarmViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 8/30/24.
//

import UIKit

class AlarmViewController: UIViewController, ConfigUI {
    
    //TODO: get으로 안읽었던 알람 불러오면 unreadId에 아이디 저장하기
    private var unreadId = [Int]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        changeReadAlarm()
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
}

extension AlarmViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlarmTableViewCell.identifier, for: indexPath) as? AlarmTableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
}

extension AlarmViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)번째 셀이 눌렸다")
    }
}

