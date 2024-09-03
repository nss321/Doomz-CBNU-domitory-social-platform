//
//  Network.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/02/20.
//

import Foundation
import UIKit
struct Network {
    
    static func getMethod<T: Codable>(url: String, completion: @escaping (Result<T, Error>) -> Void) {
        func createURL(from url: String) -> URL? {
            return URL(string: url)
        }
        //안될경우 한글이 들어가있는 url임으로addingPercentEncoding붙여서 다시 시도
        guard let url = createURL(from: url) else {
            guard let encodedUrlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let encodedURL = createURL(from: encodedUrlString) else {
                completion(.failure(NSError(domain: "InvalidURL", code: 400, userInfo: nil)))
                return
            }
            
            fetchData(from: encodedURL, completion: completion)
            return
        }
        fetchData(from: url, completion: completion)
    }
    
    private static func fetchData<T: Codable>(from url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let token = Token.shared.access
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Accesstoken")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "InvalidResponse", code: 500, userInfo: nil)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 500, userInfo: nil)))
                return
            }
            
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedObject))
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
        let token = Token.shared.access
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
    
    static func putMethod<T: Codable>(url: String, body: Data?, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            print("Invalid URL: \(url)")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let token = Token.shared.access
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Accesstoken")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = body
        
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
    
    static func postMethodBody<T: Codable>(url: String, body: Data?, completion: @escaping (Result<(T, [AnyHashable: Any]), Error>) -> Void) {
        let token = Token.shared.access
        guard var request = createRequest(url: url, token: token, contentType: "application/json") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: ["description": "URL is not valid."])))
            return
        }
        request.httpMethod = "POST"
        request.httpBody = body
        executeRequestBody(request: request, completion: completion)
    }
    
    static func createRequest(url: String, method: String = "POST", token: String, contentType: String?, body: Data? = nil) -> URLRequest? {
        guard let url = URL(string: url) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Accesstoken")
        
        if let contentType = contentType {
            request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        }
        
        request.httpBody = body
        
        return request
    }
    
    static func executeRequestBody<T: Decodable>(request: URLRequest, completion: @escaping (Result<(T, [AnyHashable: Any]), Error>) -> Void) {
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
                if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode(T.self, from: data)
                        completion(.success((decodedData, httpResponse.allHeaderFields)))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(NSError(domain: "Invalid data", code: 0, userInfo: ["description": "No data received."])))
                }
            } else {
                if let data = data {
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                        let statusError = NSError(domain: "HTTP Error", code: errorResponse.code, userInfo: [
                            "description": errorResponse.errorMessage,
                            "statusCode": errorResponse.code
                        ])
                        completion(.failure(statusError))
                    } catch {
                        let statusError = NSError(domain: "HTTP Error", code: httpResponse.statusCode, userInfo: [
                            "description": "Failed to parse error message.",
                            "statusCode": httpResponse.statusCode
                        ])
                        completion(.failure(statusError))
                    }
                } else {
                    let statusError = NSError(domain: "HTTP Error", code: httpResponse.statusCode, userInfo: [
                        "description": "No data received.",
                        "statusCode": httpResponse.statusCode
                    ])
                    completion(.failure(statusError))
                }
            }
        }
        task.resume()
    }
    
    static func executeRequest<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
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
                if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(decodedData))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(NSError(domain: "Invalid data", code: 0, userInfo: ["description": "No data received."])))
                }
            } else {
                if let data = data {
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                        let statusError = NSError(domain: "HTTP Error", code: errorResponse.code, userInfo: [
                            "description": errorResponse.errorMessage,
                            "statusCode": errorResponse.code
                        ])
                        completion(.failure(statusError))
                    } catch {
                        let statusError = NSError(domain: "HTTP Error", code: httpResponse.statusCode, userInfo: [
                            "description": "Failed to parse error message.",
                            "statusCode": httpResponse.statusCode
                        ])
                        completion(.failure(statusError))
                    }
                } else {
                    let statusError = NSError(domain: "HTTP Error", code: httpResponse.statusCode, userInfo: [
                        "description": "No data received.",
                        "statusCode": httpResponse.statusCode
                    ])
                    completion(.failure(statusError))
                }
            }
        }
        task.resume()
    }
    
    static func postMethod<T: Codable>(url: String, body: Data?, completion: @escaping (Result<T, Error>) -> Void) {
        let token = Token.shared.access
        guard var request = createRequest(url: url, token: token, contentType: "application/json") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: ["description": "URL is not valid."])))
            return
        }
        request.httpMethod = "POST"
        request.httpBody = body
        executeRequest(request: request, completion: completion)
    }
    
    static func multipartFilePostMethod<T: Codable>(url: String, image: UIImage, completion: @escaping (Result<T, Error>) -> Void) {
        let token = Token.shared.access
        let boundary = UUID().uuidString
        var data = Data()
        
        if let imageData = image.jpegData(compressionQuality: 0.1) {
            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            data.append(imageData)
            data.append("\r\n".data(using: .utf8)!)
        }
        
        data.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        guard let request = createRequest(url: url, token: token, contentType: "multipart/form-data; boundary=\(boundary)", body: data) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: ["description": "URL is not valid."])))
            return
        }
        
        executeRequest(request: request, completion: completion)
    }
    
    static func patchMethod<T: Codable>(url: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            completion(.failure(NSError(domain: "InvalidURL", code: 400, userInfo: nil)))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let token = Token.shared.access
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Accesstoken")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
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
    
    
    static func loadImage(url: String) -> UIImageView {
        let imageView = UIImageView()
        guard let imageUrl = URL(string: url) else {
            return imageView
        }
        imageView.kf.setImage(with: imageUrl)
        return imageView
    }
    
    //이 메서드는 어세스 토큰이 만료된 시점에 사용해야함
    //어세스 토큰이 만료될때 해당 메서드 사용시 리프레시토큰을 가지고 백앤드에전달하면
    //백앤드에서 다시 어세스토큰과 리프레시토큰을 발급해주는 로직
    private func updateAccessToekn() {
        guard var request = Network.createRequest(url: Url.updateAccessToken(), token: Token.shared.access, contentType: "application/json") else {
            print("URL 확인 요망")
            return
        }
        
        // 리프레시 토큰을 헤더에 추가
        request.addValue(Token.shared.refresh, forHTTPHeaderField: "refreshToken")
        
        Network.executeRequestBody(request: request) { (result: Result<(CodeResponse, [AnyHashable: Any]), Error>) in
            switch result {
            case .success(let (successCode, headers)):
                print("post 성공: \(successCode)")
                
                if let newAccessToken = headers["accessToken"] as? String,
                   let newRefreshToken = headers["refreshToken"] as? String {
                    Token.shared.access = newAccessToken
                    Token.shared.refresh = newRefreshToken
                } else {
                    print("헤더에 토큰을 찾을 수 없음")
                }
                
            case .failure(let error):
                print("토큰 갱신 실패: \(error.localizedDescription)")
            }
        }
    }
    
    //로그아웃시 사용하는 메서드(리프레시토큰을 헤더에 담아 보냄
    //기존 토큰들 삭제
    static func logout() {
        guard var request = Network.createRequest(url: Url.logout(), token: Token.shared.access, contentType: "application/json") else {
            print("URL 확인 요망")
            return
        }
        
        // 리프레시 토큰을 헤더에 추가
        request.addValue(Token.shared.refresh, forHTTPHeaderField: "refreshToken")
        
        Self.executeRequest(request: request) { (result: Result<CodeResponse, Error>) in
            switch result {
            case .success(let response):
                Token.shared.access = ""
                Token.shared.refresh = ""
                print("로그아웃 성공")
            case .failure(let error):
                print("로그아웃 실패: \(error.localizedDescription)")
            }
        }
    }
}

enum Dormitory: String {
    case 본관 = "본관"
    case 양성재 = "양성재"
    case 양진재 = "양진재"
}
