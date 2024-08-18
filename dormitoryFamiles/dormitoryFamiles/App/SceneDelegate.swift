//
//  SceneDelegate.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2023/09/04.
//

import UIKit
import StompClientLib

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func sceneDidBecomeActive(_ scene: UIScene) {
        // 앱이 포어그라운드로 전환될 때 웹소켓 연결
        WebSocketManager.shared.connectWebSocket()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // 앱이 백그라운드로 전환될 때 웹소켓 닫기
        WebSocketManager.shared.disconnectWebSocket()
    }
}
