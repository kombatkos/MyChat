//
//  DateManager.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 03.03.2021.
//

import Foundation

class DateManager {
    
    static func getDate(date: Date?) -> String {
        guard let date = date else { return "" }
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
