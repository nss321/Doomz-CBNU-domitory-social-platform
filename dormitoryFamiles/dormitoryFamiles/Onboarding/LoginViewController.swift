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
        
    }
}

