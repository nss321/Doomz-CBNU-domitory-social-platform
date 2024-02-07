//
//  Codable.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/02/08.
//

import Foundation

struct ArticleResponse: Codable {
    let code: Int
    let data: ArticleData
}

struct ArticleData: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let articleId: Int
    let nickName, profileUrl, boardType, title: String
    let content: String
    let wishCount, amIWish, commentCount, viewCount: Int
    let status, createdDate, thumbnailUrl: String
}
