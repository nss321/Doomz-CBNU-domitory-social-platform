//
//  Codable.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/02/08.
//

import Foundation

struct Article: Codable {
    let articleId: Int
    let nickName: String
    let profileUrl: String
    let boardType: String
    let title: String
    let content: String
    let CommentCount: Int
    let wishCount: Int
    let isWished: Bool
    let status: String
    let createdAt: String
    let thumbnailUrl: String?
    let viewCount: Int
}


struct ArticleData: Codable {
    let articles: [Article]
}

struct ArticleResponse: Codable {
    let code: Int
    let data: ArticleData
}

struct Post: Codable {
    let dormitoryType: String
    let boardType: String
    let title: String
    let content: String
    let tags: String
    let imagesUrls: [String]
}

struct PostResponse: Decodable {
    let code: Int
    let data: ResponseData

    struct ResponseData: Decodable {
        let articleId: Int
    }
}
