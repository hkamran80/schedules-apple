//
//  DateTime.swift
//  Schedules
//
//  Created by H. Kamran on 4/27/21.
//

import Foundation


extension Date {
    
    /// only keep hour, min, sec
    func keepOnlyTime() -> DateComponents {
        let timeComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: self)
        return timeComponents
    }
}


func getCurrentDay() -> Days? {
    let date = Date()
    let formatter = DateFormatter()

    formatter.dateFormat = "E"

    if let day = Days(rawValue: formatter.string(from: date).uppercased()) {
        return day
    } else {
        return nil
    }
}

/// difference between 2 date components
func calculateTimeDifference(startTimeComponents: DateComponents, endTimeComponents: DateComponents) -> (hour: Int?, minute: Int?, second: Int?) {
    let difference = Calendar.current.dateComponents([.hour, .minute, .second], from: startTimeComponents, to: endTimeComponents)
    return (difference.hour, difference.minute, difference.second)
}

func is24Hour() -> Bool {
    let dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)!
    return dateFormat.firstIndex(of: "a") == nil
}

// MARK: - Extensions

extension Date {
    static func - (recent: Date, previous: Date) -> (hour: Int?, minute: Int?, second: Int?) {
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: previous, to: recent)
        return (hour: components.hour, minute: components.minute, second: components.second)
    }

    func format(template: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = template

        return formatter.string(from: self)
    }
}

extension String {
    func format(template: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = template

        return formatter.date(from: self)
    }
}
