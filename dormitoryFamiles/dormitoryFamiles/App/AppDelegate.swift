//
//  AppDelegate.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2023/09/04.
//

// AppDelegate.swift
import UIKit
import StompClientLib
import KakaoSDKCommon
import KakaoSDKAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 런치스크린
        // sleep(1)
        
        // 네비게이션바 세팅
        KakaoSDK.initSDK(appKey: Token.shared.appKey)
        let backImage = UIImage(named: "navigationBack")
        UINavigationBar.appearance().backIndicatorImage = backImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
        UINavigationBar.appearance().tintColor = .black
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000, vertical: 0), for: UIBarMetrics.default)
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // 앱이 활성화될 때 웹소켓 연결
        WebSocketManager.shared.connectWebSocket()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // 앱이 백그라운드로 전환될 때 웹소켓 닫기
        WebSocketManager.shared.disconnectWebSocket()
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        return false
    }
}
