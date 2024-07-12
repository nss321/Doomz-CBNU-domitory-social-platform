//
//  UserDefaults+.swift
//  dormitoryFamiles
//
//  Created by BAE on 7/11/24.
//

import Foundation

extension UserDefaults {
    enum Keys {
        static let matchingOption = "matchingOption"
    }
    
    func setMatchingOption(_ option: [String: Any]) {
        var existingOptions = getMatchingOption() ?? [:]
        option.forEach { key, value in
            existingOptions[key] = value
        }
        set(existingOptions, forKey: Keys.matchingOption)
    }
    
    func getMatchingOption() -> [String: Any]? {
        return dictionary(forKey: Keys.matchingOption)
    }
    
    func getMatchingOptionValue(forKey key: String) -> Any? {
        return getMatchingOption()?[key]
    }
}
