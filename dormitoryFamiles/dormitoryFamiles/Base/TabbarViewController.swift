//
//  TabbarViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/02/05.
//

import UIKit

final class TabbarViewController: UITabBarController {
    
    private var urlSession: URLSession?
    private let sseManager = SSEManager()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        changeSelectedButtonTitleColor()
        getunReadMessageCount(url: Url.totalUnRead())
        sseManager.connectSse(url: Url.subscribeSse())
    }
    
    private func changeSelectedButtonTitleColor() {
        let selectedColor = UIColor.black
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)
    }
    
    private func setBadgeForThirdTab() {
        if let tabItems = tabBar.items {
            let thirdTabItem = tabItems[2]
            thirdTabItem.badgeValue = "3"
        }
    }
    
    //TODO: 실시간 웹소켓 업데이트시 해당 뱃지 실시간으로 변동되도록 설정해야함
    private func getunReadMessageCount(url: String) {
        Network.getMethod(url: url) { (result: Result<TotalUnReadResponse, Error>) in
            switch result {
            case .success(let response):
                let count = response.data.totalCount
                if count != 0 {
                    DispatchQueue.main.async {
                        if let tabItems = self.tabBar.items {
                            let thirdTabItem = tabItems[2]
                            thirdTabItem.badgeValue = String(response.data.totalCount)
                        }
                    }
                }
            case .failure(let error):
                print("Failed to fetch profile: \(error)")
            }
        }
    }
}
