//
//  Encodable+.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 7/24/24.
//

import Foundation


extension Encodable {
    func toDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
        guard let dictionary = jsonObject as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
