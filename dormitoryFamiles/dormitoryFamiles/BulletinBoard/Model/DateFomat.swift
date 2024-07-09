//
//  DateFomat.swift
//  dormitoryFamiles
//
//  Created by leehwajin on 2024/05/09.
//

import Foundation

struct DateUtility {
    
    static func yymmdd(from dateString: String, separator: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        guard let date = dateFormatter.date(from: dateString) else {
            return ""
        }
        
        let now = Date()
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date, to: now)
        
        dateFormatter.dateFormat = "yy\(separator)MM\(separator)dd"
        return dateFormatter.string(from: date)
    }
    
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
    
    //오늘을 기점으로 return "월요일(MM.DD)~일요일(MM.dd)"
    static func weekRangeString(seperator: String) -> [String] {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"+(seperator)+"dd"
        let today = Date()

        // 오늘의 요일을 가져옴 (월요일이 2, 일요일이 1)
        let weekday = calendar.component(.weekday, from: today)
        
        // 오늘의 요일을 기준으로 월요일과 일요일을 계산
        let daysFromMonday = weekday == 1 ? -6 : 2 - weekday
        let daysToSunday = weekday == 1 ? 0 : 8 - weekday
        
        // 월요일과 일요일의 날짜를 구함
        guard let monday = calendar.date(byAdding: .day, value: daysFromMonday, to: today),
              let sunday = calendar.date(byAdding: .day, value: daysToSunday, to: today) else {
            return []
        }
        
        // 날짜를 문자열로 변환
        let mondayString = dateFormatter.string(from: monday)
        let sundayString = dateFormatter.string(from: sunday)

        return [mondayString, sundayString]
    }
    
    static func addDaysToDate(dateString: String, daysToAdd: Int) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: dateString) {
            let newDate = Calendar.current.date(byAdding: .day, value: daysToAdd, to: date)!
            
            let newDateString = dateFormatter.string(from: newDate)
            
            return newDateString
        } else {
            return nil
        }
    }

}

