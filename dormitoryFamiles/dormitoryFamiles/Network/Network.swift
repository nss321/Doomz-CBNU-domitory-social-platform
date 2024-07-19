//
//  Network.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/02/20.
//

import Foundation
struct Network {
    
    static func getMethod<T: Codable>(url: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let encodedUrlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedUrlString) else {
            completion(.failure(NSError(domain: "InvalidURL", code: 400, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // "Accesstoken" 헤더에 "Bearer" 스키마를 사용해 토큰 추가
        let token = Token.shared.number
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Accesstoken")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(error ?? NSError(domain: "NetworkError", code: 500, userInfo: nil)))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(T.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    static func deleteMethod<T: Codable>(url: String, completion: @escaping (Result<T, Error>) -> Void) {
        //TODO: 여기 부분 안되서 도움을 좀 받았는데, 코드 수정해야함 작동은 잘 됨
        guard let url = URL(string: url) else {
            print("url오류")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        let token = Token.shared.number
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Accesstoken")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                guard let data = data else {
                    // 데이터가 없는 경우 적절한 에러 처리
                    completion(.failure(NSError(domain: "No data", code: 0, userInfo: ["description": "No data received from server"])))
                    return
                }
                do {
                    // 데이터를 T 타입으로 디코딩
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    // 디코딩 실패 시 에러 처리
                    completion(.failure(error))
                }
            } else {
                completion(.failure(NSError(domain: "Invalid response", code: httpResponse.statusCode, userInfo: ["description": "HTTP Status Code: \(httpResponse.statusCode)"])))
            }
        }
        task.resume()
    }
    
    static func putMethod<T: Codable>(url: String,  completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            print("Invalid URL: \(url)")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let token = Token.shared.number
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Accesstoken")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: ["description": "No HTTP response"])))
                return
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                guard let data = data else {
                    completion(.failure(NSError(domain: "No data", code: 0, userInfo: ["description": "No data received from server"])))
                    return
                }
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(NSError(domain: "Invalid response", code: httpResponse.statusCode, userInfo: ["description": "HTTP Status Code: \(httpResponse.statusCode)"])))
            }
        }
        task.resume()
    }
    
    static func postMethod<T: Codable>(url: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: ["description": "URL is not valid."])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let token = Token.shared.number
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Accesstoken")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: ["description": "No HTTP response"])))
                return
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                print("postMethod 200번대 성공")
            } else {
                print("postMethod 200번대아님 실패")
            }
        }
        task.resume()
    }
}

enum Dormitory: String {
    case 본관 = "본관"
    case 양성재 = "양성재"
    case 양진재 = "양진재"
    case 양현재 = "양현재"
}
