//
//  Codable.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/02/08.
//

import Foundation

struct Article: Codable {
    let articleId: Int
    let nickname: String?
    let profileUrl: String
    let boardType: String
    let title: String
    let content: String
    let commentCount: Int
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

struct DetailResponse: Codable {
    let code: Int
    let data: ArticleDetail
}

struct ArticleDetail: Codable {
    let articleId: Int
    let memberId: Int
    let nickname: String?
    let profileUrl: String
    let memberDormitory: String
    let articleDormitory: String
    let boardType: String
    let tags: String
    let title: String
    let content: String
    let wishCount: Int
    let isWished: Bool
    let status: String
    let createdAt: String
    let imagesUrls: [String]
    let isWriter: Bool
}


struct ReplyResponse: Codable {
    let code: Int
    let data: DataClass
}

struct DataClass: Codable {
    let totalCount: Int
    let loginMemberId: Int
    let comments: [Comment]
}

struct Comment: Codable {
    let commentId: Int
    let memberId: Int
    let profileUrl: String
    let nickname: String
    let createdAt: String
    let content: String
    let isArticleWriter: Bool
    let isDeleted: Bool
    let replyComments: [ReplyComment]?
}

struct ReplyComment: Codable {
    let replyCommentId: Int
    let memberId: Int
    let profileUrl: String
    let nickname: String
    let createdAt: String
    let content: String
    let isArticleWriter: Bool
}

struct DeleteError: Codable {
    let code: Int
    let errorMessage: String
}

struct ResponseImageUrl: Codable {
    let code: Int
    let data: ResponseImageUrlData
}

struct ResponseImageUrlData: Codable {
    let imageUrl: String
}

struct SuccessCode: Codable {
    let code: Int
}

struct LikeStatus: Codable {
    let status: Int
}

struct FollowingUserResponse: Codable {
    let code: Int
    let data: FollowingUserData
}

struct FollowingUserData: Codable {
    let totalPageNumber: Int
    let nowPageNumber: Int
    let isLast: Bool
    let memberProfiles: [MemberProfile]
}

struct MemberProfile: Codable {
    let memberId: Int
    let nickname: String
    let profileUrl: String
}

struct ChattingRoomsResponse: Codable {
    let code: Int
    let data: ChattingRoomsData
}

struct FollowingUserSearchResponse: Codable {
    let code: Int
    let data: FollowingUserSearchData
}

struct FollowingUserSearchData: Codable {
    let memberProfiles: [MemberProfile]
}

struct ChattingRoomsData: Codable {
    let nowPageNumber: Int
    let isLast: Bool
    let chatRooms: [ChattingRoom]
}

struct ChattingRoom: Codable {
    let roomId: Int
    let memberId: Int
    let memberNickname: String
    let unReadCount: Int
    let lastMessage: String
    let lastMessageTime: String
    let memberProfileUrl: String?
}

struct AllDoomzResponse: Codable {
    let code: Int
    let data: AllDoomzData
}

struct AllDoomzData: Codable {
    let memberProfiles: [MemberProfile]
}

