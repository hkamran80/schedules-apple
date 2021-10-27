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
    
    if let daySchedule = getDaySchedule(schedule: schedule) {
        let currentTimeComponents = Date().keepOnlyTime()
        
        /// return first occurrence of a period,
        /// where the current time is within its start and end.
        return daySchedule.periods.first { period in
            if
                let startDate = Calendar.current.date(from: period.startTimeComponents),
                let endDate = Calendar.current.date(from: period.endTimeComponents),
                let currentDate = Calendar.current.date(from: currentTimeComponents)
            {
                return (startDate ... endDate).contains(currentDate)
            }
            
            return false
        }
    }
    
    return nil
}

func getNextPeriod(schedule: [Day]) -> Period? {
    if let daySchedule = getDaySchedule(schedule: schedule) {
        if let currentPeriod = getCurrentPeriod(schedule: schedule) {
            
            /// return first occurrence of period,
            /// where its `startTimeComponents` matches this current period's `endTimeComponents`.
            return daySchedule.periods.first { nextPeriod in
                
                if /// convert time components to dates for comparing
                    let currentPeriodEndDate = Calendar.current.date(from: currentPeriod.endTimeComponents),
                    let nextPeriodStartDate = Calendar.current.date(from: nextPeriod.startTimeComponents)
                {
                    
                    let (tdHour, tdMinute, tdSecond) = nextPeriodStartDate - currentPeriodEndDate

                    /// the next period has an offset of 1 second, need to account for that
                    return tdHour == 0 && tdMinute == 0 && tdSecond == 1
                }
                
                return false
            }
        }
    }
    
    return nil
}
