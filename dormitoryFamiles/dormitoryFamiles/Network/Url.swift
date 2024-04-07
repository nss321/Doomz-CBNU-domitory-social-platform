//
//  Url.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/04/07.
//

import Foundation
struct Url {
    static let url = "http://43.202.254.127:8080"
    
    static var pathAllPostUrl: String {
        "/api/dormitories/\(SelectedDormitory.shared.domitory)/articles?page=0&size=10&sort=s&status=모집중".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    static var helpPostUrl: String {
        "/api/dormitories/\(SelectedDormitory.shared.domitory)/board-type/도와주세요/articles?page=0&size=10&sort=createdAt&status=모집중".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    static var togetherUrl: String {
        "/api/dormitories/\(SelectedDormitory.shared.domitory)/board-type/함께해요/articles?page=0&size=10&sort=createdAt&status=모집중".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    static var shareUrl: String {
        "/api/dormitories/\(SelectedDormitory.shared.domitory)/board-type/나눔해요/articles?page=0&size=10&sort=createdAt&status=모집중".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    static var lostUrl: String {
        "/api/dormitories/\(SelectedDormitory.shared.domitory)/board-type/분실신고/articles?page=0&size=10&sort=createdAt&status=모집중".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    
    static func searchUrl(searchText: String) -> String {
        var url: String {
            "/api/dormitories/\(SelectedDormitory.shared.domitory)/articles/search?&page=0&size=10&q=\(searchText)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        }
        return url
    }
    
    static func postRereplyUrl(replyId: Int) -> String {
        return self.url + "/api/comments/\(replyId)/replyComments"
    }
    
    static func replyUrl(id: Int) -> String {
        return self.url + "/api/articles/\(id)/comments"
    }
    
    static func postReplyUrl(id: Int) -> String {
        return self.url + "/api/articles/\(id)/comments"
    }
}
