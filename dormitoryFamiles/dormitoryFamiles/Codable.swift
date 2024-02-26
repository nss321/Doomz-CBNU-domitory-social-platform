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
    let thumbnailUrl: String
    let viewCount: Int
}


struct ArticleData: Codable {
    let articles: [Article]
}

struct ArticleResponse: Codable {
    let code: Int
    let data: ArticleData
}
