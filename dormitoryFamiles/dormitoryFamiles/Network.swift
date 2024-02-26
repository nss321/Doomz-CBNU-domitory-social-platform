//
//  Network.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/02/20.
//

import Foundation
struct Network {
    let url = "http://43.202.254.127:8080"
    
    
    
    func getAllPost(dormitory: Dormitory) {
        let url = url + "/api/dormitories/\(dormitory.rawValue)/articles"
    }
}

enum Dormitory: String {
    case 본관 = "본관"
    case 양성재 = "양성재"
    case 양진재 = "양진재"
    case 양현재 = "양현재"
}
