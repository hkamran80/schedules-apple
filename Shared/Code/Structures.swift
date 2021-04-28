//
//  Structures.swift
//  Schedules
//
//  Created by H. Kamran on 4/27/21.
//

import Foundation

// MARK: - Structures

struct Schedule: Identifiable, Hashable {
    let id: String
    let name: String
    let shortName: String
    let icon: String
    let color: String

    let schedule: [Day]

    static func == (lhs: Schedule, rhs: Schedule) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Day: Hashable {
    let day: Days
    let periods: [Period]
}

struct Period: Hashable {
    let name: String
    let startTime: String
    let endTime: String
}

// MARK: - Enumerations

enum Days: String {
    case sunday = "SUN"
    case monday = "MON"
    case tuesday = "TUE"
    case wednesday = "WED"
    case thursday = "THU"
    case friday = "FRI"
    case saturday = "SAT"
}

enum TimeCalculations {
    case currentPeriod
    case nextPeriod
}
