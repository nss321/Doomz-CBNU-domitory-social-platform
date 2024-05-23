//
//  Url.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/04/07.
//

import Foundation
struct Url {
    static let base = "http://43.202.254.127:8080"
    
    static func pathAllPostUrl(page: Int) -> String {
        return "/api/dormitories/\(SelectedDormitory.shared.domitory)/articles?page=\(page)&size=10&sort=createdAt".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    static func helpPostUrl(page: Int) -> String {
        return "/api/dormitories/\(SelectedDormitory.shared.domitory)/board-type/도와주세요/articles?page=\(page)&size=10&sort=createdAt".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    static func togetherUrl(page: Int) -> String {
        return "/api/dormitories/\(SelectedDormitory.shared.domitory)/board-type/함께해요/articles?page=\(page)&size=10&sort=createdAt".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    static func shareUrl(page: Int) -> String {
        return "/api/dormitories/\(SelectedDormitory.shared.domitory)/board-type/나눔해요/articles?page=\(page)&size=10&sort=createdAt".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    static func lostUrl(page: Int) -> String {
        return "/api/dormitories/\(SelectedDormitory.shared.domitory)/board-type/분실신고/articles?page=\(page)&size=10&sort=createdAt".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    
    static var imageToUrl: String {
        Self.base+"/api/images"
    }
    
    static var articles: String {
        Self.base+"/api/articles"
    }
    
    
    static func searchUrl(searchText: String) -> String {
        var url: String {
            "/api/dormitories/\(SelectedDormitory.shared.domitory)/articles/search?&page=0&size=10&q=\(searchText)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        }
        return url
    }
    
    static func postRereplyUrl(replyId: Int) -> String {
        return self.base + "/api/comments/\(replyId)/reply-comments"
    }
    
    static func replyUrl(id: Int) -> String {
        return self.base + "/api/articles/\(id)/comments"
    }
    
    static func postReplyUrl(id: Int) -> String {
        return self.base + "/api/articles/\(id)/comments"
    }
    
    static func deletePost(id: Int) -> String{
        return self.base + "/api/articles/\(id)"
    }
    
    static func changeStatus(id: Int, status: String) -> String {
        return self.base + "/api/articles/\(id)/status?status=\(status)"
    }

    static func deleteRereply(replyId: Int) -> String {
        return self.base + "/api/reply-comments/\(replyId)"
    }
    
    static func deleteReply(replyId: Int) -> String {
        return self.base + "/api/comments/\(replyId)"
    }
    
    static func like(id: Int) -> String {
        return self.base + "/api/articles/\(id)/wishes"
    }
}
