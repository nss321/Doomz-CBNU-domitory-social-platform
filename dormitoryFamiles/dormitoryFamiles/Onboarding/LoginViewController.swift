//
//  loginViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/01/18.
//

import UIKit
import WebKit
import KakaoSDKUser

final  class LoginViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabel()
    }
    
    private func setLabel() {
        titleLabel.text = "기숙사에 대한 정보를 담았어요!"
        titleLabel.asColor(targetString: ["기숙사", "정보"], color: .primary!)
        descriptionLabel.font = UIFont.body2
    }
    
    
    
    @IBAction func kakaoLoginbuttonTapped(_ sender: RoundButton) {
        print("로그인 버튼이 눌렸다")
        
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let error = error {
                    print("카카오톡 로그인 에러")
                } else {
                    if let token = oauthToken {
                        print("카카오톡 로그인 성공.")
                        let accessToken = token.accessToken
                        print("Access Token: \(accessToken)")
                        self.tokenToBackend(accessToken: accessToken)
                    }
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                if let error = error {
                    print("카카오톡 로그인 에러")
                } else {
                    if let token = oauthToken {
                        print("카카오톡 로그인 성공.")
                        let accessToken = token.accessToken
                        print("Access Token: \(accessToken)")
                        self.tokenToBackend(accessToken: accessToken)
                    }
                }
            }
        }
    }
    
    private func tokenToBackend(accessToken: String) {
        let requestBody: [String: Any] = [
         "accessToken": accessToken
        ]
        
        print(requestBody)
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            Network.postMethodBody(url: Url.kakaoLogin(), body: jsonData) { (result: Result<(CodeResponse, [AnyHashable: Any]), Error>) in
                switch result {
                case .success(let (successCode, headers)):
                    print("post 성공: \(successCode)")
                    if let realAccessToken = headers["accessToken"] as? String, let realRefreshToken = headers["refreshToken"] as? String {
                        Token.shared.access = realAccessToken
                        Token.shared.refresh = realRefreshToken
                        //정상적으로 토큰까지 저장되었다면 화면전환
                        //navigationPush를 하지않은이유: 뒤로가기 기능을 없애기 제거하기 위해
                        DispatchQueue.main.async {
                            if let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController {
                                tabBarController.modalPresentationStyle = .fullScreen
                                self.present(tabBarController, animated: true, completion: nil)
                            }
                        }
                        
                    }
                    
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        } catch {
            print("JSON 변환 에러: \(error)")
        }
    }
}

