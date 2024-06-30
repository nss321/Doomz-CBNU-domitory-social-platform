//
//  loginViewController.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/01/18.
//

import UIKit
import WebKit

final  class LoginViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabel()
    }
    
    private func setLabel() {
        titleLabel.text = "기숙사에 대한 정보를 담았어요!"
        titleLabel.asColor(targetString: ["기숙사", "정보"], color: .primary!)
        descriptionLabel.font = UIFont.body2
    }
    
    private func setWebviewIfNeeded() {
        if webView == nil {
            let webConfiguration = WKWebViewConfiguration()
            webView = WKWebView(frame: .zero, configuration: webConfiguration)
            webView.navigationDelegate = self
            webView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(webView)
            
            NSLayoutConstraint.activate([
                webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                webView.topAnchor.constraint(equalTo: view.topAnchor),
                webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
    }
    
    private func removeWebView() {
        webView.removeFromSuperview()
        webView = nil
    }
    
    @IBAction func kakaoLoginbuttonTapped(_ sender: RoundButton) {
        print("로그인 버튼이 눌렸다")
        setWebviewIfNeeded()
        
        DispatchQueue.main.async { [self] in
            if let url = URL(string: "http://43.202.254.127:8080/oauth2/authorization/kakao") {
                let request = URLRequest(url: url)
                webView.load(request)
            }
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            print("Navigating to URL: \(url)")
            // URL이 정확히 "http://43.202.254.127:8080/"인 경우
            if url.absoluteString == "http://43.202.254.127:8080/somin" {
                // 필요한 추가 작업이 있다면 여기서 처리
                if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                   let queryItems = components.queryItems {
                    for item in queryItems {
                        print("\(item.name): \(item.value ?? "")")
                        if item.name == "token" {
                            let token = item.value
                            print("Received token: \(token ?? "")")
                            // 여기서 토큰을 처리하는 로직을 추가하세요
                            // 예: 서버에 토큰을 보내거나, 사용자 정보를 가져오는 API를 호출하는 등의 작업
                        }
                    }
                }
            }else if url.absoluteString == "http://43.202.254.127:8080/" {
                print("Redirected URL: \(url)")
                
                // 리디렉션된 URL을 감지하여 웹뷰를 닫고 앱으로 돌아오기
                removeWebView()
                
                
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                // 탭바 컨트롤러 인스턴스 생성
                guard let tabBarController = storyboard.instantiateViewController(withIdentifier: "JoinLogic") as? UINavigationController else {
                    return
                }
                
                // 탭바 컨트롤러를 모달로 표시
                tabBarController.modalPresentationStyle = .fullScreen
                self.present(tabBarController, animated: true, completion: nil)
                
                decisionHandler(.cancel)
                return
            }
        }
        decisionHandler(.allow)
    }
    
}

