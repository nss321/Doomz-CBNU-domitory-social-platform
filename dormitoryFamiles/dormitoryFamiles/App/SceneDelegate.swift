//
//  SceneDelegate.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2023/09/04.
//

import UIKit
import StompClientLib
import KakaoSDKCommon
import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private var urlSession: URLSession?
    private let sseManager = SSEManager()
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // 앱이 포어그라운드로 전환될 때 웹소켓 연결
        WebSocketManager.shared.connectWebSocket()
        sseManager.connectSse(url: Url.subscribeSse())
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // 앱이 백그라운드로 전환될 때 웹소켓 닫기
        WebSocketManager.shared.disconnectWebSocket()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        KakaoSDK.initSDK(appKey: Token.shared.appKey)
        return false
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
}
