//
//  AlarmType.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 9/1/24.
//

import Foundation

enum AlarmType: String {
    case ARTICLE_COMMENT = "님이 -에 댓글을 남겼습니다."
    case ARTICLE_WISH = "님이 -에 찜하기를 눌렀습니다."
    case ARTICLE_REPLY_COMMENT = "님이 -에 대댓글을 남겼습니다."
    case MEMBER_FOLLOW = "님이 팔로우 했습니다."
    case CHAT = "님이 채팅을 보냈습니다."
    case MATCHING_WISH = "님이 룸메이트 찜을 눌렀어요."
    case MATCHING_REQUEST = "님이 룸메이트 신청을 보냈어요."
    case MATCHING_REJECT = "님에게 보낸 룸메이트 신청이 거절되었어요."
    case MATCHING_ACCEPT = "님에게 보낸 룸메이트 신청이 수락되었어요."
}

extension AlarmType {
    static func matchingDescription(_ name: String) -> AlarmType? {
        switch name {
        case "ARTICLE_COMMENT": return .ARTICLE_COMMENT
        case "ARTICLE_WISH": return .ARTICLE_WISH
        case "ARTICLE_REPLY_COMMENT": return .ARTICLE_REPLY_COMMENT
        case "MEMBER_FOLLOW": return .MEMBER_FOLLOW
        case "CHAT": return .CHAT
        case "MATCHING_WISH": return .MATCHING_WISH
        case "MATCHING_REQUEST": return .MATCHING_REQUEST
        case "MATCHING_REJECT": return .MATCHING_REJECT
        case "MATCHING_ACCEPT": return .MATCHING_ACCEPT
        default: return nil
        }
    }
}
