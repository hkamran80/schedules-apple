//
//  DateTime.swift
//  Schedules
//
//  Created by H. Kamran on 4/27/21.
//

import Foundation

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

func getSplitTime() -> String {
    let date = Date()
    let formatter = DateFormatter()

    formatter.dateFormat = "HH-mm-ss"
    return formatter.string(from: date)
}

func calculateTimeDifference(startTimeString: String, endTimeString: String) -> (hour: Int?, minute: Int?, second: Int?) {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH-mm-ss"

    if let startTime = formatter.date(from: startTimeString), let endTime = formatter.date(from: endTimeString) {
        return endTime - startTime
    } else {
        return (nil, nil, nil)
    }
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
