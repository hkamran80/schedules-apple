//
//  Schedule.swift
//  Schedules
//
//  Created by H. Kamran on 4/27/21.
//

import Foundation

func getDaySchedule(schedule: [Day]) -> Day? {
    if let currentDay = getCurrentDay(), let daySchedule = schedule.first(where: { $0.day == currentDay }) {
        return daySchedule
    }

    return nil
}

func getCurrentPeriod(schedule: [Day]) -> Period? {
    if let daySchedule = getDaySchedule(schedule: schedule), let time = Int(getSplitTime().replacingOccurrences(of: "-", with: "")) {
        for period in daySchedule.periods {
            if let periodStart = Int(period.startTime.replacingOccurrences(of: "-", with: "")), let periodEnd = Int(period.endTime.replacingOccurrences(of: "-", with: "")) {
                if periodStart <= time, time <= periodEnd {
                    return period
                }
            }
        }
    }

    return nil
}

func getNextPeriod(schedule: [Day]) -> Period? {
    if let daySchedule = getDaySchedule(schedule: schedule), let currentEndTimeRaw = (getCurrentPeriod(schedule: schedule)?.endTime.format(template: "HH-mm-ss")?.addingTimeInterval(1).format(template: "HH-mm-ss")) {
        let currentEndTime = Int(currentEndTimeRaw.replacingOccurrences(of: "-", with: ""))

        for period in daySchedule.periods {
            if let periodStart = Int(period.startTime.replacingOccurrences(of: "-", with: "")) {
                if periodStart == currentEndTime {
                    return period
                }
            }
        }
    }

    return nil
}
