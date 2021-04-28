//
//  ScheduleView.swift
//  Schedules
//
//  Created by H. Kamran on 4/27/21.
//

import SwiftUI

struct ScheduleView: View {
    let schedule: Schedule

    @State private var currentPeriodName: String = "Loading..."
    @State private var timeRemaining: String = "00:00:00"
    @State private var nextPeriodName: String = "Loading..."
    @State private var nextPeriodStartingTime: String = "00:00"

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(alignment: .leading) {
            #if os(iOS)
            Text(schedule.name)
                .font(.headline)
                .padding(8)
                .padding(.bottom, 16)
            #endif
            
            ScheduleCard(header: currentPeriodName, content: timeRemaining)
            ScheduleCard(header: nextPeriodName, content: nextPeriodStartingTime)
        }
        .frame(maxWidth: .infinity)
        .onReceive(timer, perform: { _ in
            updateSchedule()
        })
    }

    func updateSchedule() {
        if let currentPeriod = getCurrentPeriod(schedule: schedule.schedule) {
            currentPeriodName = currentPeriod.name

            let (hour, minute, second) = calculateTimeDifference(startTimeString: getSplitTime(), endTimeString: currentPeriod.endTime)
            timeRemaining = "\(String(format: "%02d", hour ?? 0)):\(String(format: "%02d", minute ?? 0)):\(String(format: "%02d", second ?? 0))"
        }

        if let nextPeriod = getNextPeriod(schedule: schedule.schedule) {
            nextPeriodName = nextPeriod.name
            nextPeriodStartingTime = nextPeriod.startTime.format(template: "HH-mm-ss")?.format(template: is24Hour() ? "HH:mm" : "h:mm a") ?? "00:00"
        }
    }
}

#if DEBUG
struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView(schedule: Schedule(id: "sch-demo-abc", name: "Demo Schedule", shortName: "Demo", icon: "mdiTestTube", color: "#13323C", schedule: [Day(day: .monday, periods: [Period(name: "Demo Period I", startTime: "08-30-00", endTime: "15-20-00")])]))
    }
}
#endif
