//
//  Network.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/02/20.
//

import Foundation
struct Network {
    static let url = "http://43.202.254.127:8080"
    static let pathAllPost = "/api/dormitories/본관/articles?page=0&size=10&sort=s&status=모집중".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    

    static func getMethod<T: Codable>(url: String, completion: @escaping (Result<T, Error>) -> Void) {
        let url = URL(string: url)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(T.self, from: data)
                    completion(.success(response))
                } catch {
                    completion(.failure(error))
                }
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
