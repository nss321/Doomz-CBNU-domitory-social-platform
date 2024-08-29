//
//  NetworkService.swift
//  dormitoryFamiles
//
//  Created by BAE on 8/29/24.
//

import Foundation
import Combine

final class NetworkService {
    
    /// 네트워크 요청을 위한 레이어를 싱글톤 객체로 구현
    static let shared = NetworkService()
    
    private let baseURL: String
//    private var cancellables = Set<AnyCancellable>()
    
    private init(baseURL: String = Url.base) {
        self.baseURL = baseURL
    }
    
    struct ServerResponse<T: Codable>: Codable {
        let code: Int
        let data: T?
        let errorMessage: String?
    }
    
    /// Combine 사용을 위한 Network Publisher
    func request<T: Codable>(
        endpoint: String,
        method: String = "GET",
        headers: [String: String]? = nil,
        decoder: JSONDecoder = JSONDecoder()
    ) -> AnyPublisher<T, Error> {
        
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        let token = Token.shared.number
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Accesstoken")
        
        headers?.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        
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
