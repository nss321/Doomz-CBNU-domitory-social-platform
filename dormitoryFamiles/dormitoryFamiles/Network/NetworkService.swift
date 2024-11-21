//
//  NetworkService.swift
//  dormitoryFamiles
//
//  Created by BAE on 8/29/24.
//

import Foundation
import Combine

/// Combine 사용을 위한 Network Service Class
final class NetworkService {
    
    /// 네트워크 요청을 위한 레이어를 싱글톤 객체로 구현
    static let shared = NetworkService()
    
    private let baseURL: String
    
    private init(baseURL: String = Url.base) {
        self.baseURL = baseURL
    }
    
    struct ServerResponse<T: Codable>: Codable {
        let code: Int
        let data: T?
        let errorMessage: String?
    }
    
    
    /// 공통 네트워크 요청 메서드
    private func makeRequest<T: Codable>(
        endpoint: String,
        method: String,
        headers: [String: String]? = nil,
        body: Data? = nil,
        decoder: JSONDecoder = JSONDecoder()
    ) -> AnyPublisher<T, Error> {
        
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        // 기본 헤더 추가
        let token = Token.shared.access
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Accesstoken")
        
        headers?.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        if let body = body {
            request.httpBody = body
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .tryMap { data in
                let response = try decoder.decode(ServerResponse<T>.self, from: data)
                
                switch response.code {
                case 200...299:
                    if let data = response.data {
                        return data
                    } else {
                        throw APIError.unknown("Data is missing.")
                    }
                    
                case 404:
                    if let errorMessage = response.errorMessage {
                        throw APIError.notFound(errorMessage)
                    } else {
                        throw APIError.notFound("Resource not found")
                    }
                    
                case 500...599:
                    if let errorMessage = response.errorMessage {
                        throw APIError.serverError(errorMessage)
                    } else {
                        throw APIError.serverError("Server encountered an error")
                    }
                    
                default:
                    let errorMessage = response.errorMessage ?? "An unknown error occurred"
                    throw APIError.unknown(errorMessage)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func getRequest<T: Codable>(
        endpoint: String,
        headers: [String: String]? = nil,
        decoder: JSONDecoder = JSONDecoder()
    ) -> AnyPublisher<T, Error> {
        return makeRequest(endpoint: endpoint, method: "GET", headers: headers, body: nil, decoder: decoder)
    }
    
    func postRequest<T: Codable, U: Codable>(
        endpoint: String,
        body: U,
        headers: [String: String]? = nil,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) -> AnyPublisher<T, Error> {
        do {
            let bodyData = try encoder.encode(body)
            return makeRequest(endpoint: endpoint, method: "POST", headers: headers, body: bodyData, decoder: decoder)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    func putRequest<T: Codable, U: Codable>(
        endpoint: String,
        body: U,
        headers: [String: String]? = nil,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) -> AnyPublisher<T, Error> {
        do {
            let bodyData = try encoder.encode(body)
            return makeRequest(endpoint: endpoint, method: "PUT", headers: headers, body: bodyData, decoder: decoder)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    func deleteRequest<T: Codable>(
        endpoint: String,
        headers: [String: String]? = nil,
        decoder: JSONDecoder = JSONDecoder()
    ) -> AnyPublisher<T, Error> {
        return makeRequest(endpoint: endpoint, method: "DELETE", headers: headers, decoder: decoder)
    }
    
}

enum APIError: LocalizedError {
    case notFound(String)
    case serverError(String)
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .notFound(let message):
            return "Not Found: \(message)"
        case .serverError(let message):
            return "Server Error: \(message)"
        case .unknown(let message):
            return "Unknown Error: \(message)"
        }
    }
}
