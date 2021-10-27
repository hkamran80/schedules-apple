//
//  ScheduleView.swift
//  Schedules
//
//  Created by H. Kamran on 4/27/21.
//

import SwiftUI
import UserNotifications

struct ScheduleView: View {
    let schedule: Schedule

    @State private var currentPeriodName: String = "Loading..."
    @State private var timeRemaining: String = "00:00:00"
    @State private var nextPeriodName: String = "Loading..."
    @State private var nextPeriodStartingTime: String = "00:00"

    @State private var notificationPermissionGranted: Bool = false

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            VStack(spacing: 16) {
                ScheduleCard(header: currentPeriodName, content: timeRemaining)
                ScheduleCard(header: nextPeriodName, content: nextPeriodStartingTime)
            }
            .padding(16)
            
            Spacer()
        }
        .background(Color(.secondarySystemBackground))
        .navigationTitle(schedule.shortName)
        .navigationBarTitleDisplayMode(.inline)
        .onReceive(timer, perform: { _ in
            updateSchedule()
        })
        .onAppear(perform: requestNotificationPermission)
    }

    func updateSchedule() {
        if let currentPeriod = getCurrentPeriod(schedule: schedule.schedule) {
            currentPeriodName = currentPeriod.name
            
            let currentTimeComponents = Date().keepOnlyTime()
            let (tdHour, tdMinute, tdSecond) = calculateTimeDifference(startTimeComponents: currentTimeComponents, endTimeComponents: currentPeriod.endTimeComponents)
            
            if let hour = tdHour, let minute = tdMinute, let second = tdSecond {
                timeRemaining = "\(String(format: "%02d", hour)):\(String(format: "%02d", minute)):\(String(format: "%02d", second))"

                // Notifications
                var notificationInterval: NotificationIntervals?
                if hour == 1, minute == 0, second == 0 {
                    notificationInterval = .oneHour
                } else if hour == 0 {
                    if minute == 30, second == 0 {
                        notificationInterval = .thirtyMinutes
                    } else if minute == 15, second == 0 {
                        notificationInterval = .fifteenMinutes
                    } else if minute == 10, second == 0 {
                        notificationInterval = .tenMinutes
                    } else if minute == 5, second == 0 {
                        notificationInterval = .fiveMinutes
                    } else if minute == 1, second == 0 {
                        notificationInterval = .oneMinute
                    } else if minute == 0, second == 30 {
                        notificationInterval = .thirtySeconds
                    }
                }

                if let notificationInterval = notificationInterval {
                    showNotification(notificationInterval: notificationInterval)
                }
            } else {
                timeRemaining = "00:00:00"
            }
        }

        if let nextPeriod = getNextPeriod(schedule: schedule.schedule) {
            nextPeriodName = nextPeriod.name
            
            let dateFormatter = DateFormatter()
            if is24Hour() {
                dateFormatter.dateFormat = "h:mm a"
            } else {
                dateFormatter.dateFormat = "HH:mm"
            }
            
            if let nextPeriodStartDate = Calendar.current.date(from: nextPeriod.startTimeComponents) {
                let nextPeriodStartingTimeString = dateFormatter.string(from: nextPeriodStartDate)
                nextPeriodStartingTime = nextPeriodStartingTimeString
            }
        }
    }

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                notificationPermissionGranted = true
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func showNotification(notificationInterval: NotificationIntervals) {
        if notificationPermissionGranted {
            let content = UNMutableNotificationContent()
            content.title = "\(schedule.shortName) - \(currentPeriodName)"
            content.subtitle = "\(notificationInterval.rawValue) remaining"
            content.categoryIdentifier = schedule.id
            content.sound = UNNotificationSound.default

            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
            UNUserNotificationCenter.current().add(request)
        }
    }
}

#if DEBUG
struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView(
            schedule: Schedule(
                id: "sch-demo-abc",
                name: "Demo Schedule",
                shortName: "Demo",
                icon: "mdiTestTube",
                color: "#13323C",
                schedule: [
                    Day(
                        day: .monday,
                        periods: [
                            Period(
                                name: "Demo Period I",
                                startTimeComponents: DateComponents(hour: 8, minute: 30),
                                endTimeComponents: DateComponents(hour: 15, minute: 20)
                            )
                        ]
                    )
                ]
            )
        )
    }
}
#endif
