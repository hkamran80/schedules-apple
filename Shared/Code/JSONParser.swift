//
//  JSONParser.swift
//  Schedules
//
//  Created by H. Kamran on 2/5/21.
//

import Foundation
import SwiftyJSON

func importSchedule(scheduleData: Data) -> [Schedule] {
    var schedules = [Schedule]()
    
    do {
        let json = try JSON(data: scheduleData)
        
        for (key, value): (String, JSON) in json {
            var allPeriods = [Day]()
            for (day, periods): (String, JSON) in value["schedule"] {
                var dayPeriods = [Period]()
                
                for (periodName, periodTimes): (String, JSON) in periods {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HH-mm-ss"
                    
                    let startTimeString = periodTimes[0].stringValue
                    let endTimeString = periodTimes[1].stringValue
                    
                    if
                        let startDate = dateFormatter.date(from: startTimeString),
                        let endDate = dateFormatter.date(from: endTimeString)
                        
                        
                        
                    {
                        /// only use hour, min, sec
                        let startTimeComponents = startDate.keepOnlyTime()
                        let endTimeComponents = endDate.keepOnlyTime()
                        
                        dayPeriods.append(
                            Period(
                                name: periodName,
                                startTimeComponents: startTimeComponents,
                                endTimeComponents: endTimeComponents
                            )
                        )
                    }
                }
                
                if ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"].contains(day) {
                    if let dayCase = Days(rawValue: day) {
                        allPeriods.append(Day(day: dayCase, periods: dayPeriods))
                    }
                }
            }
            
//            print("Datys: \(allPeriods)")
            let schedule = Schedule(id: key, name: value["name"].stringValue, shortName: value["shortName"].stringValue, icon: value["icon"].stringValue, color: value["color"].stringValue, schedule: allPeriods)
            
            schedules.append(schedule)
        }
        
        return schedules
    } catch {
        return []
    }
}
