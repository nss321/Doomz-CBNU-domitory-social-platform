//
//  Token.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/03/25.
//

import Foundation

final class Token {
    static let shared = Token()
    var number = ""
    
    private init() { }
}
