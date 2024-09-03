//
//  SSEManager.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 8/31/24.
//

import Foundation

class SSEManager: NSObject, URLSessionDataDelegate {
    
    private var urlSession: URLSession?
    
    func connectSse(url: String) {
        guard let url = URL(string: url) else {
            print("url 확인 요망")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(Token.shared.access)", forHTTPHeaderField: "Accesstoken")
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 3600
        configuration.timeoutIntervalForResource = 3600
        urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        let task = urlSession?.dataTask(with: request)
        task?.resume()
    }
    
    // URLSessionDataDelegate 메서드를 사용해야지만 SSE구현가능
    // URLSession은 응답을 받으면 끝나는 형식
    // URLSessionDataDelegate는 응답을 받아도 유지
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if let message = String(data: data, encoding: .utf8) {
            print("SSE 메시지 수신: \(message)")
            
            if message == "new notification created" {
                NotificationCenter.default.post(name: NSNotification.Name("NewNotificationCreated"), object: nil)
            }
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            print("SSE 연결 종료: \(error.localizedDescription)")
            
            let nsError = error as NSError
            if nsError.domain == NSURLErrorDomain && nsError.code == NSURLErrorTimedOut {
                //서버 타임아웃이 났다면
                //connectSse(url: Url.subscribeSse())
            }
        } else {
            print("SSE 연결 정상 종료")
        }
    }
}
