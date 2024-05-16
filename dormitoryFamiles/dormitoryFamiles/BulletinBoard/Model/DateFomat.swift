//
//  DateFomat.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/05/09.
//

import Foundation

struct DateUtility {
    static func formattedDateString(from dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }
        
        let now = Date()
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date, to: now)
        
        if let year = components.year, year > 0 {
            dateFormatter.dateFormat = "yy.MM.dd"
            return dateFormatter.string(from: date)
        } else if let month = components.month, month > 0 {
            dateFormatter.dateFormat = "yy.MM.dd"
            return dateFormatter.string(from: date)
        } else if let day = components.day, day > 6 {
            dateFormatter.dateFormat = "yy.MM.dd"
            return dateFormatter.string(from: date)
        } else if let day = components.day, day > 0 {
            return "\(day)일 전"
        } else if let hour = components.hour, hour > 0 {
            return "\(hour)시간 전"
        } else if let minute = components.minute, minute > 1 {
            return "\(minute)분 전"
        } else {
            return "방금 전"
        }
    }
}

