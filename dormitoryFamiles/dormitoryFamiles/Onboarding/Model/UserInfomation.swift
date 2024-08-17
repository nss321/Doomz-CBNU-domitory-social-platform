//
//  UserInfomation.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 8/18/24.
//

import Foundation

final class UserInformation{
    static let shared = UserInformation()
    private init() {}
    
    private var nickname = ""
    private var studentCardImageUrl = ""
    private var collegeType = ""
    private var departmentType = ""
    private var studentNumber = 0
    private var dormitoryType = ""
    
    func setNickname(text: String) {
        self.nickname = text
    }
    
    func setProfile(collegeType: String, departmentType: String, studentNumber: Int, dormitoryType: String) {
        self.collegeType = collegeType
        self.departmentType = departmentType
        self.studentNumber = studentNumber
        self.dormitoryType = dormitoryType
    }
    
    func setStudentCardImageUrl(url: String) {
        self.studentCardImageUrl = url
    }
}
