//
//  Date + Extension.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 26.02.2021.
//

import Foundation

extension Date {
    
    func enterDate(hour: Int, minute: Int, day: Int, month: Int = 1, year: Int = 2021) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.day = day
        dateComponents.month = month
        dateComponents.year = year
        
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)
        
        return date
    }
    
    func dateToString() -> String {
        let date = self
        let dateFormatter = DateFormatter()
        let day = Calendar.current.component(.day, from: date)
        
        let currentDate = Date()
        let currentDay = Calendar.current.component(.day, from: currentDate)
        
        if day != currentDay {
            dateFormatter.dateFormat = "dd MMM"
            return dateFormatter.string(from: date)
        } else {
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: date)
        }
    }
}
